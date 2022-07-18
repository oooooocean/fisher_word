const isTest = true;

enum Environment {
  local,
  product;

  String get host {
    switch (this) {
      case Environment.local:
        return 'http://127.0.0.1:8000/';
      case Environment.product:
        return 'https://fisher.sesame.fun/';
    }
  }
}

const currentEnvironment = Environment.product;
