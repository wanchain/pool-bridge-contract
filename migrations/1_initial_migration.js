const Migrations = artifacts.require("Migrations");
const CommonProxy = artifacts.require("CommonProxy");
const Layer2BridgeDelegate = artifacts.require("Layer2BridgeDelegate");

module.exports = async function (deployer) {
  // deployer.deploy(Migrations);
  await deployer.deploy(Layer2BridgeDelegate);
  let layer2bridge = await Layer2BridgeDelegate.deployed();
  console.log('layer2bridge', layer2bridge.address);

  const proxyAdmin = '0x2AA0175Eb8b0FB818fFF3c518792Cc1a327a1338';

  const admin = '0x4Cf0A877E906DEaD748A41aE7DA8c220E4247D9e';

  const tokenAddress = ''

  await deployer.deploy(CommonProxy, layer2bridge.address, proxyAdmin, '0x');

  let proxy = await Layer2BridgeDelegate.at((await CommonProxy.deployed()).address);
  console.log('proxy', proxy.address);

  await proxy.initialize(admin, tokenAddress);
};
