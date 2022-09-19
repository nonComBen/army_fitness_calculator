import * as admin from "firebase-admin";
import * as Functions from "firebase-functions";
import {CLOUD_REGION} from "./constants";
import {PurchaseHandler} from "./purchase-handler";
import {GooglePlayPurchaseHandler} from "./google-play.purchase-handler";
import {AppStorePurchaseHandler} from "./app-store.purchase-handler";
import {productDataMap} from "./products";

// The Cloud Functions for Firebase SDK to create Cloud Functions
// and setup triggers.
// const functions = require("firebase-functions");

export type IAPSource = "google_play" | "app_store";

// The Firebase Admin SDK to access Cloud Firestore.
// const admin = require("firebase-admin");
admin.initializeApp({projectId: "army-leaders-book"});
const functions = Functions.region(CLOUD_REGION);
// Initialize the IAP repository that the purchase handlers depend on
// Initialize an instance of each purchase handler,
// and store them in a map for easy access.
const purchaseHandlers: { [source in IAPSource]: PurchaseHandler } = {
  "google_play": new GooglePlayPurchaseHandler(),
  "app_store": new AppStorePurchaseHandler(),
};
// Verify Purchase Function
interface VerifyPurchaseParams {
    source: IAPSource;
    verificationData: string;
    productId: string;
}

// Handling of purchase verifications
export const verifyPurchase = functions.https.onCall(
    async (
        data: VerifyPurchaseParams,
    ): Promise<boolean> => {
    // App Check
      // if (context.app == undefined) {
      //   console.warn("verifyPurchase called when failed app check");
      //   throw new HttpsError(
      //       "failed-precondition",
      //       "The function must be called from an App Check verified app.",
      //   );
      // }
      // Check authentication
      // if (!context.auth) {
      //   console.warn("verifyPurchase called when not authenticated");
      //   throw new HttpsError(
      //       "unauthenticated",
      //       "Request was not authenticated.",
      //   );
      // }
      // Get the product data from the map
      const productData = productDataMap[data.productId];
      // If it was for an unknown product, do not process it.
      if (!productData) {
        console.warn(`verifyPurchase called for an unknown product 
          ("${data.productId}")`);
        return false;
      }
      // If it was for an unknown source, do not process it.
      if (!purchaseHandlers[data.source]) {
        console.warn(`verifyPurchase called for an unknown source 
          ("${data.source}")`);
        return false;
      }
      // Process the purchase for the product
      return purchaseHandlers[data.source].verifyPurchase(
          productData,
          data.verificationData,
      );
    });
