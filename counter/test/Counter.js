const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Counter', () => {
  let counter

  beforeEach(async () => {
    const Counter = await ethers.getContractFactory('Counter')
    counter = await Counter.deploy()
  })

  it('should return the initial count', async () => {
    const count = await counter.getCount()
    expect(count).to.equal(0, 'Initial count should be 0')
  })

  it('should increment the count', async () => {
    await counter.increment()
    const count = await counter.getCount()
    expect(count).to.equal(1, 'count should be 1')
  })

  it('should decrement the count', async () => {
    await counter.increment()
    const count = await counter.getCount()
    expect(count).to.equal(-1, 'count should be -1')
  })
})
