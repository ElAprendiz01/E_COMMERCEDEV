
using APLICATION.Interfaces;
using APLICATION.Services;
using INFRASTRUCTURE.DB;
using INFRASTRUCTURE.JWT;
using INFRASTRUCTURE.Repository;
using Microsoft.AspNetCore.Builder;


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

// Configuración de CORS
builder.Services.AddCors(op =>
{
    op.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyHeader()
              .AllowAnyMethod()
              .AllowAnyOrigin();
    });
});


// Conexión base de datos 
var connectionString = builder.Configuration.GetConnectionString("Default");
builder.Services.AddSingleton(new DBconexionfactory(connectionString!));
builder.Services.AddScoped<IJwtService, JwtService>();
builder.Services.AddScoped<IProvidersRepository, ProvidersRepository>();
builder.Services.AddScoped<ProvidersServices>();
builder.Services.AddScoped<IUsersRepository, UsersRepository>();
builder.Services.AddScoped<UsersServices>();
builder.Services.AddScoped<IPaymentMethodTypesRepository, PaymentMethodTypesRepository>();
builder.Services.AddScoped<PaymentMethodTypesServices>();
builder.Services.AddScoped<ISubCategoriesRepository, SubCategoriesRepository>();
builder.Services.AddScoped<SubCategoriesServices>();
builder.Services.AddScoped<ISegmentsRepository, SegmentsRepository>();
builder.Services.AddScoped<SegmentsServices>();
builder.Services.AddScoped<IProductsRepository, ProductsRepository>();
builder.Services.AddScoped<ProductsServices>();
builder.Services.AddScoped<IPaymentOrdersRepository, PaymentOrdersRepository>();
builder.Services.AddScoped<PaymentOrdersServices>();
builder.Services.AddScoped<IStockMovementsRepository, StockMovementsRepository>();
builder.Services.AddScoped<StockMovementsServices>();
builder.Services.AddScoped<ICurrenciesRepository, CurrenciesRepository>();
builder.Services.AddScoped<CurrenciesServices>();
builder.Services.AddScoped<IUserPaymentMethodsRepository, UserPaymentMethodsRepository>();
builder.Services.AddScoped<UserPaymentMethodsServices>();
builder.Services.AddScoped<IMarksRepository, MarksRepository>();
builder.Services.AddScoped<MarksServices>();
builder.Services.AddScoped<IUserAddressRepository, UserAddressRepository>();
builder.Services.AddScoped<UserAddressServices>();
builder.Services.AddScoped<IPaymentOrderDetailsRepository, PaymentOrderDetailsRepository>();
builder.Services.AddScoped<PaymentOrderDetailsServices>();
builder.Services.AddScoped<IStockMovementDetailsRepository, StockMovementDetailsRepository>();
builder.Services.AddScoped<StockMovementDetailsServices>();
builder.Services.AddScoped<ICartDetailsRepository, CartDetailsRepository>();
builder.Services.AddScoped<CartDetailsServices>();
builder.Services.AddScoped<ICategoriesRepository, CategoriesRepository>();
builder.Services.AddScoped<CategoriesServices>();
builder.Services.AddScoped<IStatusRepository, StatusRepository>();
builder.Services.AddScoped<StatusServices>();
builder.Services.AddScoped<IAttributeProductsRepository, AttributeProductsRepository>();
builder.Services.AddScoped<AttributeProductsServices>();
builder.Services.AddScoped<IProductIdentificatorsRepository, ProductIdentificatorsRepository>();
builder.Services.AddScoped<ProductIdentificatorsServices>();
builder.Services.AddScoped<IMarkByProvidersRepository, MarkByProvidersRepository>();
builder.Services.AddScoped<MarkByProvidersServices>();
builder.Services.AddScoped<IProductImagesRepository, ProductImagesRepository>();
builder.Services.AddScoped<ProductImagesServices>();
builder.Services.AddScoped<IProductVariableTypesRepository, ProductVariableTypesRepository>();
builder.Services.AddScoped<ProductVariableTypesServices>();
builder.Services.AddScoped<IStocksRepository, StocksRepository>();
builder.Services.AddScoped<StocksServices>();
builder.Services.AddScoped<IAttributeProductVariablesRepository, AttributeProductVariablesRepository>();
builder.Services.AddScoped<AttributeProductVariablesServices>();









builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();




var app = builder.Build();


app.UseCors("AllowAll"); // Primero CORS

app.UseStaticFiles(); // Habilitar servidor de archivos estáticos (imágenes en wwwroot)

app.UseSwagger();
app.UseSwaggerUI(s =>
{
    s.SwaggerEndpoint("/swagger/v1/swagger.json", "ECCOMERCEDEV");
    s.RoutePrefix = string.Empty;
});

app.UseAuthentication();
app.UseAuthorization(); // Único punto de autorización

app.MapControllers();

app.Run();
