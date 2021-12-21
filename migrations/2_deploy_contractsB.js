const RandomMachine = artifacts.require("RandomMachine");
const DiceGame = artifacts.require("DiceGame");

module.exports = function(deployer) {
  deployer.deploy(DiceGame, RandomMachine.address);
};
