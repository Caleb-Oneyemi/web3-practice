import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers'
import chai, { expect } from 'chai'
import { ethers } from 'hardhat'

describe('Adoption', () => {
  const deployAdoptionFixture = async () => {
    const [_, testUser] = await ethers.getSigners()
    const Adoption = await ethers.getContractFactory('Adoption')
    const adoption = await Adoption.deploy()

    const conn = adoption.connect(testUser) as any

    return { conn, adoption, testUser }
  }

  describe('Adopting a pet and retrieving account addresses', () => {
    it('should fail if pet id is less than 1', async () => {
      const { conn } = await loadFixture(deployAdoptionFixture)

      const testPetId = 0
      await expect(conn.adopt(testPetId)).to.be.revertedWith(
        'pet id must be in range 1 to 10',
      )
    })

    it('should fail if pet id is greater than 10', async () => {
      const { conn } = await loadFixture(deployAdoptionFixture)

      const testPetId = 11
      await expect(conn.adopt(testPetId)).to.be.revertedWith(
        'pet id must be in range 1 to 10',
      )
    })

    it('can fetch the address of an owner by pet id', async () => {
      const { conn, adoption, testUser } = await loadFixture(
        deployAdoptionFixture,
      )

      const testPetId = 1
      await conn.adopt(testPetId)

      const adopter = await adoption.adopters(testPetId - 1)
      expect(adopter).to.equal(testUser.address)
    })

    it(`can fetch the collection of all pet owners' addresses`, async () => {
      const { conn, adoption, testUser } = await loadFixture(
        deployAdoptionFixture,
      )

      const testPetId = 1
      await conn.adopt(testPetId)

      const adopters = await adoption.getAdopters()
      expect(adopters[testPetId - 1]).to.equal(testUser.address)
    })
  })
})
