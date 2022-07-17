// deps
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

// uut
import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:web3dart/web3dart.dart';

// globals
String PRIVATE = "";

void main() async {
  setUp(() {
    dotenv.testLoad(fileInput: File('assets/.env').readAsStringSync());
    PRIVATE = dotenv.env['MATIC'] ??= "";
  });

  test('Lets load', () async {
    String rpcUrl = "https://matic-mumbai.chainstacklabs.com";
    Credentials creds = formCredential(PRIVATE);
    EthereumAddress address = await creds.extractAddress();
    Web3Client ethClient = rpcConnect(rpcUrl, address);
    double balance = await getBalance(ethClient, address);
    print("balance");
    print(balance);
  });
}
