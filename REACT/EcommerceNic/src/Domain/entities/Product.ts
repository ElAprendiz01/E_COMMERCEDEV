export interface Product {
  id: string;
  productId?: number;
  title: string;
  subtitle: string;
  numericPrice: number;
  tag: string;
  brand: string;
  category: string;
  image: string;
  categoryId?: number;
  stockAvailable?: number;
  productVariableId?: number;
}
