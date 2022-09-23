const ethers = require('ethers');

const { INTER_ADDRESS, RPC_ARRAY } = require('../constants.js');

const INTER_ABI = require('../abi/inter.json');

const ethersConnect = {
  provider: () => {
    let provider;
    let arrayCount = 0;
    while (provider == null) {
      provider = new ethers.providers.JsonRpcProvider(RPC_ARRAY[++arrayCount]);
    }
    return provider;
  },
  test: () => {
    console.log(RPC_ARRAY[0]);
  },
  interContract: (provider) => {
    if (provider == null) {
      provider = ethersConnect.provider();
    }
    const inter = new ethers.Contract(INTER_ADDRESS, INTER_ABI, provider);
    // owner = await inter.owner();
    // console.log(owner);
    return inter;
  },
  interListener: async (contract) => {
    let _invoice;
    contract.on('Invoice', (invoice, event) => {
      console.log(invoice);

      console.log(event.blockNumber);
      console.log(event);
      _invoice = invoice;
    });
    return await '_invoice';
  },
};

module.exports = ethersConnect;
