import hre from 'hardhat'

const main = async () => {
  const [deployer] = await hre.ethers.getSigners()

  console.log('Deployer ---', deployer.address)

  const adoption = await hre.ethers.deployContract('Adoption')
  await adoption.waitForDeployment()

  const addr = await adoption.getAddress()

  console.log(`Contract successfully deployed.\nContract address : ${addr}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
