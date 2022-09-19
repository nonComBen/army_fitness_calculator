import {ProductData} from "./products";
/**
   * It creates Puchase Handler class
   */
export abstract class PurchaseHandler {
  /**
   * It verifies purchase
   * @param {ProductData} productData
   * @param {string} token
   * @return {void}
   */
  async verifyPurchase(
      productData: ProductData,
      token: string,
  ): Promise<boolean> {
    switch (productData.type) {
      case "SUBSCRIPTION":
        return this.handleSubscription(productData, token);
      case "NON_SUBSCRIPTION":
        return this.handleNonSubscription(productData, token);
      default:
        return false;
    }
  }

  abstract handleNonSubscription(
      productData: ProductData,
      token: string,
  ): Promise<boolean>;

  abstract handleSubscription(
      productData: ProductData,
      token: string,
  ): Promise<boolean>;
}
