const ethers = require('./lib/web3Connect.js');

async function main() {
  let contract = ethers.interContract();

  ethers.interListener(contract);
}

main();
