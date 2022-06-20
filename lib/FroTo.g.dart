// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"invoice","type":"string"}],"name":"PaymentRequest","type":"event"},{"inputs":[{"internalType":"string","name":"_invoice","type":"string"}],"name":"newInvoice","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'FroTo');

class FroTo extends _i1.GeneratedContract {
  FroTo(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> newInvoice(String _invoice,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '34c1cca8'));
    final params = [_invoice];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all PaymentRequest events emitted by this contract.
  Stream<PaymentRequest> paymentRequestEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('PaymentRequest');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return PaymentRequest(decoded);
    });
  }
}

class PaymentRequest {
  PaymentRequest(List<dynamic> response) : invoice = (response[0] as String);

  final String invoice;
}
