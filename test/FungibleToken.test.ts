import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers'
import { expect } from 'chai'
import { ethers } from 'hardhat'
import { MyFungibleToken } from '../typechain-types/contracts/FungibleToken.sol'

describe('Fungible Token', () => {
  const fixture = async () => {
    const [testUser, testUser2, testUser3] = await ethers.getSigners()
    const MyFungibleToken = await ethers.getContractFactory('MyFungibleToken')
    const token = (await MyFungibleToken.deploy(
      testUser,
    )) as unknown as MyFungibleToken

    const conn = token.connect(testUser)

    return { conn, token, testUser, testUser2, testUser3 }
  }

  it('should return correct decimal places', async () => {
    const { token } = await loadFixture(fixture)
    const decimals = await token.decimals()
    expect(decimals).to.equal(18)
  })

  it('should return valid total supply', async () => {
    const { token } = await loadFixture(fixture)
    const decimals = await token.decimals()
    const expectedSupply = ethers.parseUnits('10000', decimals)
    expect((await token.totalSupply()).toString()).to.equal(expectedSupply)
  })

  it('should transfers the right amount of tokens to/from an account', async () => {
    const amount = 1000
    const { token, testUser, testUser2 } = await loadFixture(fixture)

    await expect(
      token.transfer(testUser2.address, amount),
    ).to.changeTokenBalances(
      token,
      [testUser.address, testUser2.address],
      [-amount, amount],
    )
  })

  it('the smart contact emits a transfer event with the right arguments', async () => {
    const amount = 1000
    const { token, testUser, testUser2 } = await loadFixture(fixture)
    const decimals = await token.decimals()

    await expect(
      token.transfer(
        testUser2.address,
        ethers.parseUnits(amount.toString(), decimals),
      ),
    )
      .to.emit(token, 'Transfer')
      .withArgs(
        testUser.address,
        testUser2.address,
        ethers.parseUnits(amount.toString(), decimals),
      )
  })

  it('should allow for allowance approvals and queries', async () => {
    const approvedAmount = 1000
    const { token, testUser, testUser2 } = await loadFixture(fixture)
    const decimals = await token.decimals()

    expect(await token.allowance(testUser.address, testUser2.address)).to.equal(
      0,
    )
    await token.approve(
      testUser2.address,
      ethers.parseUnits(approvedAmount.toString(), decimals),
    )
    expect(await token.allowance(testUser.address, testUser2.address)).to.equal(
      ethers.parseUnits(approvedAmount.toString(), decimals),
    )
  })

  it('emits an approval event with the right arguments', async () => {
    const approvedAmount = 1000
    const { token, testUser, testUser2 } = await loadFixture(fixture)
    const decimals = await token.decimals()

    await expect(
      token.approve(
        testUser2.address,
        ethers.parseUnits(approvedAmount.toString(), decimals),
      ),
    )
      .to.emit(token, 'Approval')
      .withArgs(
        testUser.address,
        testUser2.address,
        ethers.parseUnits(approvedAmount.toString(), decimals),
      )
  })
})
