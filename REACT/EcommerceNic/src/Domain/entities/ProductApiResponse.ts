export interface ProductsPageResponse {
  codigo: number;
  msj: string;
  pageNumber: number;
  pageSize: number;
  totalRows: number;
  data: ApiProduct[];
}

export interface ApiProduct {
  productID: number;
  productName: string;
  productVariableID?: number;
  productVariableName?: string;
  productVariablePrice?: number;
  currencyID?: number;
  currencyISO?: string;
  categoryID?: number;
  categoryName?: string;
  subcategoryID?: number;
  subcategoryName?: string;
  segmentID?: number;
  segmentName?: string;
  markID?: number;
  markName?: string;
  providerID?: number;
  providerName?: string;
  stockID?: number;
  stockAvilable?: number;
  stockFactoryDate?: string;
  stockExpirationDate?: string;
  productImageURL?: string;
}
