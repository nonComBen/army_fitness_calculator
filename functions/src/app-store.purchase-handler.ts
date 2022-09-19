import {PurchaseHandler} from "./purchase-handler";
import {ProductData} from "./products";
import * as appleReceiptVerify from "node-apple-receipt-verify";
import {APP_STORE_SHARED_SECRET} from "./constants";

// Add typings for missing property in library interface.
declare module "node-apple-receipt-verify" {
    interface PurchasedProducts {
        originalTransactionId: string;
    }
}

/**
 * AppStorePurchaseHandler class
 */
export class AppStorePurchaseHandler extends PurchaseHandler {
  /**
   * constructor for class AppStorePurchaseHandler
   */
  constructor() {
    super();
    appleReceiptVerify.config({
      verbose: true,
      secret: APP_STORE_SHARED_SECRET,
      extended: true,
      excludeOldTransactions: true,
      environment: ["production", "sandbox"],
    });
  }

  /**
 * It returns whether purchase is valid
 * @param {string} productData
 * @param {string} token
 * @return {bool} is valid
 */
  async handleNonSubscription(
      productData: ProductData,
      token: string,
  ): Promise<boolean> {
    return this.handleValidation(token);
  }

  /**
 * It returns whether purchase is valid
 * @param {string} productData
 * @param {string} token
 * @return {bool} is valid
 */
  async handleSubscription(
      productData: ProductData,
      token: string,
  ): Promise<boolean> {
    return this.handleValidation(token);
  }

  /**
 * It returns whether purchase is valid
 * @param {string} token
 * @return {bool} is valid
 */
  private async handleValidation(
      token: string,
  ): Promise<boolean> {
    // Validate receipt and fetch the products
    let products: appleReceiptVerify.PurchasedProducts[];
    try {
      products = await appleReceiptVerify.validate({receipt: token});
      console.log(`Purchased Products: ${products}`);
      for (let i = 0; i < products.length; i++) {
        console.log(`Expiration Date: ${products[i].expirationDate}`);
      }
    } catch (e) {
      if (e instanceof appleReceiptVerify.EmptyError) {
        // Receipt is valid but it is now empty.
        console.warn(
            "Received valid empty receipt");
        return false;
      } else if (e instanceof
                appleReceiptVerify.ServiceUnavailableError) {
        console.warn(
            "App store is currently unavailable, could not validate");
        // Handle app store services not being available
        return false;
      }
      console.warn(e);
      return false;
    }
    return true;
  }
}
