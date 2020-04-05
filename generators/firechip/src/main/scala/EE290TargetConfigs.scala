package firesim.firesim

import freechips.rocketchip.config.{Parameters, Config}
import freechips.rocketchip.subsystem._

import firesim.bridges._
import firesim.configs._

//============================================================================
// EE290-2 FireSim Gemmini Configurations
//============================================================================
class FireSimGemminiEE290Lab2RocketConfig extends Config(
  new WithInclusiveCache ++
  gemmini.WithEE290Lab2GemminiConfig() ++
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)


class FireSimGemminiEE290Lab2BigSPRocketConfig extends Config(
  new WithInclusiveCache ++
  gemmini.WithEE290Lab2LargeSPGemminiConfig() ++ 
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)

class FireSimGemminiEE290Lab3RocketConfig extends Config(
  new WithInclusiveCache ++
  gemmini.WithEE290Lab3GemminiConfig() ++ 
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)


class FireSimGemminiEE290Lab3SmallSPRocketConfig extends Config(
  new WithInclusiveCache ++
  gemmini.WithEE290Lab3SmallSPGemminiConfig() ++
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)

