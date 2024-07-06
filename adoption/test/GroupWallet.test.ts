import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers'
import { expect } from 'chai'
import { ethers } from 'hardhat'
import { GroupWallet } from '../typechain-types/GroupWallet'

describe('Group Wallet', () => {
  const groupWalletFixture = async () => {
    const [_, testUser] = await ethers.getSigners()
    const GroupWallet = await ethers.getContractFactory('GroupWallet')
    const groupWallet = (await GroupWallet.deploy()) as unknown as GroupWallet

    const conn = groupWallet.connect(testUser)

    return { conn, groupWallet, testUser }
  }

  it('should return correct initial wallet balance', async () => {
    const { conn } = await loadFixture(groupWalletFixture)

    const balance = await conn.getWalletBalance()

    expect(balance).to.equal(0)
  })
})
