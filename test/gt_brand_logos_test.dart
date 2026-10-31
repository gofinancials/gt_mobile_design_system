import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _base =
    'https://raw.githubusercontent.com/gofinancials/gt_images/refs/heads/main/brand_logos';

void main() {
  group('GtNetworkImages.bankLogo', () {
    test('matches a bank however the gateway spells it', () {
      const cases = {
        'Sterling Bank': 'banks/sterling_bank.webp',
        'GTBank': 'banks/gtbank_plc.webp',
        'Guaranty Trust Bank': 'banks/gtbank_plc.webp',
        'Zenith Bank': 'banks/zenith_bank_plc.webp',
        'Kuda MFB': 'banks/kuda_mfb.webp',
        'KUDA MICROFINANCE BANK': 'banks/kuda_mfb.webp',
        'Moniepoint MFB': 'banks/moniepoint.webp',
        'Paystack-Titan': 'banks/paystack_titan.webp',
        'Opay': 'banks/paycom_opay.webp',
        'OPay Digital Services Limited (OPay)': 'banks/paycom_opay.webp',
        'Access Bank': 'banks/access_bank_nigeria.webp',
        'Access Bank (Diamond)': 'banks/access_bank_nigeria.webp',
        'UBA': 'banks/united_bank_for_africa.webp',
        'FCMB': 'banks/first_city_monument_bank.webp',
        'First Bank': 'banks/first_bank_of_nigeria.webp',
        '9PSB': 'banks/9_payment_service_bank.webp',
      };
      for (final MapEntry(key: name, value: path) in cases.entries) {
        expect(GtNetworkImages.bankLogo(name), '$_base/$path', reason: name);
      }
    });

    test('has no logo for a bank it does not know', () {
      expect(GtNetworkImages.bankLogo('Nowhere Savings'), isNull);
      expect(GtNetworkImages.bankLogo(''), isNull);
    });
  });

  group('GtNetworkImages.billerLogo', () {
    test('matches a biller by the leading words of its name', () {
      const cases = {
        'MTN': 'billers/mtn.webp',
        'mtn': 'billers/mtn.webp',
        'Airtel': 'billers/airtel.webp',
        'GLO': 'billers/glo.webp',
        '9mobile': 'billers/t2_mobile.webp',
        'Etisalat': 'billers/t2_mobile.webp',
        'DStv': 'billers/dstv.webp',
        'DStv Compact': 'billers/dstv.webp',
        'GOtv Max': 'billers/gotv.webp',
        'StarTimes': 'billers/startime.webp',
        'Spectranet': 'billers/spectranet.webp',
        'Ikeja Electric': 'billers/ikedc_ikeja.webp',
        'Eko Electricity': 'billers/ekedc_eko.webp',
        'Ibadan Electric Prepaid': 'billers/ibedc_ibadan.webp',
        'Port Harcourt Electric': 'billers/phedc_ph.webp',
        'AEDC': 'billers/aedc_abuja.webp',
      };
      for (final MapEntry(key: name, value: path) in cases.entries) {
        expect(GtNetworkImages.billerLogo(name), '$_base/$path', reason: name);
      }
    });

    test('has no logo for a biller it does not know', () {
      expect(GtNetworkImages.billerLogo('LCC Toll'), isNull);
      expect(GtNetworkImages.billerLogo('Global Insurance'), isNull);
      expect(GtNetworkImages.billerLogo(''), isNull);
    });
  });
}
