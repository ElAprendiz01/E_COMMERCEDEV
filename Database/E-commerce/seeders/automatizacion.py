import os
import re
import time
import urllib.parse
import base64
import requests
import pyodbc
from playwright.sync_api import sync_playwright

# ==========================================
# CONFIGURACIÓN
# ==========================================
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
USER_DATA_DIR = os.path.join(BASE_DIR, "data")

PRIMARY_SAVE_FOLDER = r"C:\hector\E_COMMERCEDEV\API\API_ECCOMERCEDEV\PRESENTACION\wwwroot\uploads\products"
if os.path.exists(os.path.dirname(PRIMARY_SAVE_FOLDER)):
    SAVE_FOLDER = PRIMARY_SAVE_FOLDER
else:
    SAVE_FOLDER = os.path.join(BASE_DIR, "uploads", "products")

os.makedirs(SAVE_FOLDER, exist_ok=True)
os.makedirs(USER_DATA_DIR, exist_ok=True)

CREATOR_ID = 1
SERVER = "CLARK"
DATABASE = "DB_ECOMMERCE"

PRODUCTS = [
    {"id": 12, "name": "Zapatillas Nike Court Vision Low", "var_name": "TALLA 42 (9.5 US) - Gris"},
    {"id": 13, "name": "Zapatillas Nike Downshifter 12", "var_name": "TALLA 43 (10 US) - Negro/Azul"},
    {"id": 22, "name": "Zapatillas Nike Revolution 6 Flyease", "var_name": "TALLA 41 - Azul/Gris"},
    {"id": 23, "name": "Zapatillas Nike Pegasus 40 Premium", "var_name": "TALLA 42 - Negro/Dorado"},
    {"id": 57, "name": "Laptop Dell XPS 13", "var_name": "16GB RAM - 512GB SSD - Color Plata"},
]

def sanitize_filename(name: str) -> str:
    return re.sub(r'[^a-zA-Z0-9]', '', name)

def clean_search_query(name: str, var_name: str) -> str:
    text = f"{name} {var_name}"
    text = re.sub(r'\(.*?\)', '', text)
    text = re.sub(r'\b(TALLA|\d+GB|\d+TB|\d+US|RAM|SSD|ROM)\b', '', text, flags=re.IGNORECASE)
    text = re.sub(r'[-/,]', ' ', text)
    return ' '.join(text.split())

def get_db_connection():
    conn_str = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};Trusted_Connection=yes;"
    conn = pyodbc.connect(conn_str)
    conn.autocommit = True
    return conn

def call_sp_product_image(product_id: int, image_url: str, description: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        sql = """
            DECLARE @o_code INT, @o_message VARCHAR(255), @o_templateId INT;
            
            EXEC [SQM_GENERAL].[sp_ProductImages_Create]
                @productImageProductId = ?,
                @productImageURL = ?,
                @productImageDescription = ?,
                @productImageIsPrincipal = 1,
                @productImageCreatorId = ?,
                @productImageStatusId = 1,
                @o_code = @o_code OUTPUT,
                @o_message = @o_message OUTPUT,
                @o_templateId = @o_templateId OUTPUT;
                
            SELECT @o_code AS Code, @o_message AS Message, @o_templateId AS TemplateId;
        """
        cursor.execute(sql, (product_id, image_url, description, CREATOR_ID))
        row = cursor.fetchone()
        conn.commit()

        if row:
            print(f"  [DB Result] Code: {row.Code} | Message: {row.Message} | ID: {row.TemplateId}")
        conn.close()
    except Exception as e:
        print(f"  [DB Error] Error al registrar en BD: {e}")

def download_image_safe(url: str) -> bytes:
    if url.startswith("data:image"):
        header, encoded = url.split(",", 1)
        return base64.b64decode(encoded)
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    resp = requests.get(url, headers=headers, timeout=8, verify=False)
    resp.raise_for_status()
    return resp.content

def main():
    requests.packages.urllib3.disable_warnings()

    with sync_playwright() as p:
        try:
            context = p.chromium.launch_persistent_context(
                user_data_dir=USER_DATA_DIR,
                headless=False,
                viewport={"width": 1280, "height": 800},
                user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
                args=["--disable-blink-features=AutomationControlled"]
            )
        except Exception as launch_err:
            print(f"[INFO] Perfil en uso ({launch_err}). Iniciando ventana alternativa de Chromium...")
            browser = p.chromium.launch(
                headless=False,
                args=["--disable-blink-features=AutomationControlled"]
            )
            context = browser.new_context(
                viewport={"width": 1280, "height": 800},
                user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            )

        search_page = context.pages[0] if context.pages else context.new_page()

        for item in PRODUCTS:
            product_id = item["id"]
            product_name = item["name"]
            search_query = clean_search_query(product_name, item["var_name"])
            
            clean_filename = f"{sanitize_filename(product_name)}.jpg"
            file_path = os.path.join(SAVE_FOLDER, clean_filename)
            relative_url = f"/uploads/products/{clean_filename}"

            print(f"\nBuscando imagen en pantalla para [{product_id}] {product_name}...")
            print(f"  Query: '{search_query}'")

            encoded_query = urllib.parse.quote(search_query)
            search_url = f"https://www.google.com/search?q={encoded_query}&udm=2"

            img_saved = False

            try:
                search_page.goto(search_url, wait_until="domcontentloaded", timeout=15000)
                search_page.wait_for_timeout(1500)

                # Aceptar cookies si aparece banner
                try:
                    btn_accept = search_page.locator("button:has-text('Aceptar todo'), button:has-text('I agree'), button:has-text('Acepto')")
                    if btn_accept.count() > 0 and btn_accept.first.is_visible():
                        btn_accept.first.click()
                        search_page.wait_for_timeout(1000)
                except Exception:
                    pass

                # Selectores actualizados orientados a elementos interactivos visibles
                grid_items = search_page.locator("div[data-rel], div[jsaction*='click'], h3 a, a[role='link'] img:visible").all()

                if grid_items:
                    for target_item in grid_items[:3]: # Intentar con los 3 primeros si el primero falla
                        try:
                            if target_item.is_visible():
                                target_item.scroll_into_view_if_needed()
                                target_item.click(force=True, timeout=3000)
                                search_page.wait_for_timeout(2000)

                                # Selector robusto para la imagen HD en el panel lateral
                                side_img_locator = search_page.locator("div[role='dialog'] img[src^='http'], div[jsname] img[src^='http']")
                                
                                target_src = None
                                if side_img_locator.count() > 0:
                                    for i in range(side_img_locator.count()):
                                        s_element = side_img_locator.nth(i)
                                        s_src = s_element.get_attribute("src") or s_element.get_attribute("data-src") or ""
                                        if s_src.startswith("http") and "google.com" not in s_src and "gstatic.com" not in s_src:
                                            target_src = s_src
                                            break

                                # Intentar descargar por URL la versión HD
                                if target_src:
                                    try:
                                        img_data = download_image_safe(target_src)
                                        if len(img_data) > 10000:
                                            with open(file_path, 'wb') as f:
                                                f.write(img_data)
                                            print(f"  [OK Direct HD] Guardada imagen HD desde fuente ({len(img_data)//1024} KB): {file_path}")
                                            img_saved = True
                                            break
                                    except Exception as dl_err:
                                        print(f"  [INFO] Descarga directa bloqueada ({dl_err}), tomando screenshot...")

                                # Captura de la pantalla si se bloquea la URL original
                                if not img_saved and side_img_locator.count() > 0:
                                    side_element = side_img_locator.first
                                    if side_element.is_visible():
                                        side_element.screenshot(path=file_path)
                                        size_kb = os.path.getsize(file_path) // 1024
                                        if size_kb > 5: # Comprobar que no capturó una imagen vacía
                                            print(f"  [OK Screenshot HD] Capturada imagen renderizada ({size_kb} KB): {file_path}")
                                            img_saved = True
                                            break

                        except Exception as click_err:
                            continue

                # Fallback solo si los métodos anteriores no obtuvieron imagen
                if not img_saved:
                    all_imgs = search_page.locator("img:visible").all()
                    for img_elem in all_imgs:
                        src = img_elem.get_attribute("src") or img_elem.get_attribute("data-src") or ""
                        if not src or "google.com" in src or "gstatic.com" in src:
                            continue
                        if src.startswith("data:image/svg") or src.startswith("data:image/gif"):
                            continue
                        if "encrypted-tbn" in src or src.startswith("data:image") or src.startswith("http"):
                            try:
                                fallback_data = download_image_safe(src)
                                if len(fallback_data) > 3000: # Exigir al menos 3KB para evitar miniaturas corruptas
                                    with open(file_path, 'wb') as f:
                                        f.write(fallback_data)
                                    print(f"  [OK Fallback] Guardada miniatura aceptable ({len(fallback_data)} bytes): {file_path}")
                                    img_saved = True
                                    break
                            except Exception:
                                continue

                if img_saved:
                    description = f"Imagen principal - {product_name}"
                    call_sp_product_image(product_id, relative_url, description)
                else:
                    print(f"  [WARN] No se pudo obtener ninguna imagen para {product_name}.")

            except Exception as e:
                print(f"  [ERROR] Falló el procesamiento para {product_name}: {e}")

            time.sleep(1.5)

        context.close()

if __name__ == "__main__":
    main()