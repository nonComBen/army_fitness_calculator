export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export const productDataMap: { [productId: string]: ProductData } = {
  "premium_upgrade": {
    productId: "premium_upgrade",
    type: "NON_SUBSCRIPTION",
  },
};
