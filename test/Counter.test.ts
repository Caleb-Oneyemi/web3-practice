import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('Counter', () => {
  let counter: any

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
    await counter.decrement()
    const count = await counter.getCount()
    expect(count).to.equal(-1, 'count should be -1')
  })
})
