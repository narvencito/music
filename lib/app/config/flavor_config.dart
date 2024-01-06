// ignore_for_file: constant_identifier_names

enum Flavor {
  DEV,
  STG,
  PROD,
}

class InitFlavorConfig {
  static Flavor? appFlavor;

  static String get building {
    return appFlavor.toString();
  }

  static String get urlApp {
    switch (appFlavor!) {
      case Flavor.DEV:
        return 'https://api-gateway.pronabec.gob.pe:8443';
      case Flavor.STG:
        return 'https://api-test.pronabec.gob.pe:8443';
      case Flavor.PROD:
        return 'https://api.pronabec.gob.pe:8443';
    }
  }

  static String get urlAuth {
    switch (appFlavor!) {
      case Flavor.DEV:
        return 'https://sso-demo3.pronabec.gob.pe:8444/realms/concursos/protocol/openid-connect/token';
      case Flavor.STG:
        return 'https://sso-test.pronabec.gob.pe:8444/realms/concursos/protocol/openid-connect/token';
      case Flavor.PROD:
        return 'https://sso.pronabec.gob.pe:8444/realms/concursos/protocol/openid-connect/token';
    }
  }

  static String get grantType {
    switch (appFlavor!) {
      case Flavor.DEV:
        return 'client_credentials';
      case Flavor.STG:
        return 'client_credentials';
      case Flavor.PROD:
        return 'client_credentials';
    }
  }

  static String get clientId {
    switch (appFlavor!) {
      case Flavor.DEV:
        return 'app-perubeca';
      case Flavor.STG:
        return 'app-perubeca';
      case Flavor.PROD:
        return 'pronabec-app';
    }
  }

  static String get clientSecret {
    switch (appFlavor!) {
      case Flavor.DEV:
        return 'TBVlA5pDdmI9sL2WfTBTCdfi9WwIyhMl';
      case Flavor.STG:
        return 'iJCxBMK100y4Ri6sIZU9TBZ4bwIEwExb';
      case Flavor.PROD:
        return 'pNYlfEf9fWqDRDvOEcDylFg9TvCCb0Ot';
    }
  }
}
