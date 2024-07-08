import hre from 'hardhat'

const main = async () => {
  const [deployer] = await hre.ethers.getSigners()

  console.log('Deployer ---', deployer.address)

  const gw = await hre.ethers.deployContract('GroupWallet')
  await gw.waitForDeployment()

  const addr = await gw.getAddress()

  console.log(`Contract successfully deployed.\nContract address : ${addr}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
