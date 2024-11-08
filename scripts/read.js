const { ethers } = require('hardhat');

// Load env variables
require('dotenv').config();

const managerContractAddress = '0x52555F4E27d66e11ff5371F88d6D426aC32b708f';
const shareContractAddress = '0xA688e049F4E7126E953eA9684A8c2BdDB1A72315';

async function main() {
	const managerContract = (await ethers.getContractFactory('HouseformManager')).attach(managerContractAddress);
	const shareContract = (await ethers.getContractFactory('HouseformShare')).attach(shareContractAddress);

	console.log(`Share contract address: ${await managerContract.shareContract()}`);
	console.log(`Share contract name: ${await shareContract.name()}`);
	console.log(`Share contract symbol: ${await shareContract.symbol()}`);

	console.log(`Projects: ${await managerContract.getProjects()}`);
	console.log(`Share cost: ${await managerContract.getShareCost(0)}`);

	console.log(
		`Balance of project #0 shares: ${await shareContract.balanceOf('0xA688e049F4E7126E953eA9684A8c2BdDB1A72315', 0)}`,
	);
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
