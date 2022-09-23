const chai = require('chai');
const assert = require('chai').assert;

const ethers = require('../lib/web3Connect.js');

describe('Testing RPC connection', () => {
  it('Checks for a new block', async () => {
    let contract = ethers.interContract();
    // const provider = await web3Connect.provider();

    // console.log('end: ' + (await provider.getBlockNumber()));

    // provider.on('block', (data) => {
    //   console.log('new block');
    //   console.log(data);
    // });
    let invoice = null;
    invoice = await ethers.interListener(contract).then((result) => {
      console.log(result);
      done();
    });
  });
  //   it('Listens to an event', async () => {
  //     filter = {
  //       address: THE_ADDRESS_OF_YOUR_CONTRACT,
  //       topics: [
  //         // the name of the event, parnetheses containing the data type of each event, no spaces
  //         utils.id('Transfer(address,address,uint256)'),
  //       ],
  //     };
  //     provider.on(filter, () => {
  //       // do whatever you want here
  //       // I'm pretty sure this returns a promise, so don't forget to resolve it
  //     });
  //   });
});
