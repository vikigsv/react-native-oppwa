/**
 * @providesModule Oppwa
 * @flow
 */
import { NativeModules, NativeEventEmitter } from 'react-native';
import INTERNALS from './internals';
import { isObject, isString, isAndroid } from './utils';

const OppwaCoreModule = NativeModules.RNOppwa;

class OppwaCore {
  constructor() {
    if (!OppwaCoreModule) {
      throw new Error(INTERNALS.ERROR_MISSING_CORE);
    }
  }

  updateCheckoutID(checkoutId) {
    if (!checkoutId) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('checkoutId'));
    }

    OppwaCoreModule.updateCheckoutID(checkoutId);
  }

  /**
   * SDK transactionPayment
   *
   * @param options
   * @return Promise
   */
  transactionPayment(options: Object = {}) {
    if (!isObject(options)) {
      throw new Error(INTERNALS.ERROR_INIT_OBJECT);
    }

    if (!options.checkoutID) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('checkoutID'));
    }
    if (!options.holderName) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('holderName'));
    }

    if (!options.cardNumber) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('cardNumber'));
    }

    if (!options.paymentBrand) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('paymentBrand'));
    }

    if (!options.expiryMonth) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('expiryMonth'));
    }

    if (!options.expiryYear) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('expiryYear'));
    }

    if (!options.cvv) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('cvv'));
    }

    if (!options.shopperResultURL) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('shopperResultURL'));
    }

    return OppwaCoreModule.transactionPayment(options);
  }

  chinaUnionPaytransactionPayment(options: Object = {}) {
    if (!isObject(options)) {
      throw new Error(INTERNALS.ERROR_INIT_OBJECT);
    }

    if (!options.checkoutID) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('checkoutID'));
    }
    if (!options.holderName) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('holderName'));
    }

    if (!options.shopperResultURL) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('shopperResultURL'));
    }

    return OppwaCoreModule.chinaUnionPaytransactionPayment(options);
  }

  isValidHolderName(options: Object = {}) {
    if (!isObject(options)) {
      throw new Error(INTERNALS.ERROR_INIT_OBJECT);
    }

    if (!options.cardHolderName) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('cardHolderName'));
    }

    return OppwaCoreModule.isValidHolderName(options);
  }

  isValidCVV(options: Object = {}) {
    if (!isObject(options)) {
      throw new Error(INTERNALS.ERROR_INIT_OBJECT);
    }

    if (!options.cvv) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('cvv'));
    }

    return OppwaCoreModule.isValidCVV(options);
  }

  isValidExpiryDate(options: Object = {}) {
    if (!isObject(options)) {
      throw new Error(INTERNALS.ERROR_INIT_OBJECT);
    }

    if (!options.expiryMonth) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('expiryMonth'));
    }

    if (!options.expiryYear) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('expiryYear'));
    }

    return OppwaCoreModule.isValidExpiryDate(options);
  }

  isValidNumber(options: Object = {}) {
    if (!isObject(options)) {
      throw new Error(INTERNALS.ERROR_INIT_OBJECT);
    }

    if (!options.cardNumber) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('cardNumber'));
    }

    return OppwaCoreModule.isValidNumber(options);
  }

  isChinaUnionPayValidHolderName(options: Object = {}) {
    if (!isObject(options)) {
      throw new Error(INTERNALS.ERROR_INIT_OBJECT);
    }

    if (!options.cardHolderName) {
      throw new Error(INTERNALS.ERROR_MISSING_OPT('cardHolderName'));
    }

    return OppwaCoreModule.isChinaUnionPayValidHolderName(options);
  }
}

export default new OppwaCore();
