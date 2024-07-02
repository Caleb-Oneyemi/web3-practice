const { ethers } = require('hardhat')

const main = async () => {
  const [deployer] = await ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer.address)

  const contract = await ethers.deployContract('Counter')
  const addr = await contract.getAddress()

  console.log('Contract address:', addr)
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
