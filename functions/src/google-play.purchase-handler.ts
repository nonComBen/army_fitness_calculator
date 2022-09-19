import {PurchaseHandler} from "./purchase-handler";
import {ProductData} from "./products";
import {ANDROID_PACKAGE_ID} from "./constants";
import {GoogleAuth} from "google-auth-library";
import {androidpublisher_v3 as AndroidPublisherApi} from "googleapis";
import * as credentials from "./assets/service-account.json";

/**
 * GooglePlayPurchaseHandler class
 */
export class GooglePlayPurchaseHandler extends PurchaseHandler {
    private androidPublisher: AndroidPublisherApi.Androidpublisher;
    /**
     * constructs GooglePlayPurchaseHandler class
     * @param {IapRepository} iapRepository
    */
    constructor() {
      super();
      this.androidPublisher = new AndroidPublisherApi.Androidpublisher({
        auth: new GoogleAuth(
            {
              credentials,
              scopes: ["https://www.googleapis.com/auth/androidpublisher"],
            }),
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
      try {
        // Verify purchase with Google
        const response = await this.androidPublisher.purchases.products.get(
            {
              packageName: ANDROID_PACKAGE_ID,
              productId: productData.productId,
              token,
            },
        );
        // Make sure an order id exists
        if (!response.data.orderId) {
          console.error("Could not handle purchase without order id");
          return false;
        }
        if (response.data.purchaseState == 1) {
          console.error("Purchase status is cancelled");
          return false;
        }
        return true;
      } catch (e) {
        console.error(e);
        return false;
      }
    }

    /**
     * It returns whether purchase is valid
     * @param {string} productData data
     * @param {string} token
     * @returnd {bool} is valid
     */
    async handleSubscription(
        productData: ProductData,
        token: string,
    ): Promise<boolean> {
      try {
        // Verify the purchase with Google
        const response = await this.androidPublisher.purchases.subscriptions
            .get(
                {
                  packageName: ANDROID_PACKAGE_ID,
                  subscriptionId: productData.productId,
                  token,
                },
            );
        // Make sure an order id exists
        if (!response.data.orderId) {
          console.error("Could not handle purchase without order id");
          return false;
        }
        // If a subscription suffix is present (..#) extract the orderId.
        let orderId = response.data.orderId;
        const orderIdMatch = /^(.+)?[.]{2}[0-9]+$/g.exec(orderId);
        if (orderIdMatch) {
          orderId = orderIdMatch[1];
        }
        console.log({
          rawOrderId: response.data.orderId,
          newOrderId: orderId,
        });
        return true;
      } catch (e) {
        console.error(e);
        return false;
      }
    }
}
