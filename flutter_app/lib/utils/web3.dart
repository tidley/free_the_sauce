import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

Credentials formCredential(String private) {
  return EthPrivateKey.fromHex(private);
}

Web3Client rpcConnect(String rpcUrl, EthereumAddress address) {
  return Web3Client(rpcUrl, Client());
}

Future<double> getBalance(Web3Client ethClient, EthereumAddress address) async {
  EtherAmount balance = await ethClient.getBalance(address);
  return balance.getValueInUnit(EtherUnit.ether);
}
