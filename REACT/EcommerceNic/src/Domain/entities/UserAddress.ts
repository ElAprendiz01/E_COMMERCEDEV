export interface UserAddress {
  userAddressId?: number;
  userAddressUserId?: number;
  userAddressCountryId?: number;
  countryName?: string;
  userAddressZIPCode?: number;
  userAddressDescription: string;
  userAddressIsPrincipal?: boolean;
  userAddressCreatorId?: number;
  userAddressStatusId?: boolean | number;
}
