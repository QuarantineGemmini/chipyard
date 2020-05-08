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

//============================================================================
// EE290-2 FireSim Configurations (gemmini1)
//============================================================================
class FireSimGemminidim32sp16acc64bus128 extends Config(
  new WithInclusiveCache ++
  gemmini.WithGemminidim32sp16acc64bus128() ++
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)

//============================================================================
// EE290-2 FireSim Configurations (gemmini2)
//============================================================================
class FireSimGemmini2dim32sp16acc64bus128 extends Config(
  new WithInclusiveCache ++
  gemmini.WithGemmini2dim32sp16acc64bus128() ++
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)

//============================================================================
// EE290-2 FireSim Configurations (FgGemmini2)
//============================================================================
class FireSimFgGemmini2dim32fg8RocketConfig extends Config(
  new WithInclusiveCache ++
  gemmini.WithFgGemmini2dim32fg8() ++
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)

class FireSimFgGemmini2dim16fg4RocketConfig extends Config(
  new WithInclusiveCache ++
  gemmini.WithFgGemmini2dim16fg4() ++
  new WithNBigCores(1) ++
  new FireSimRocketChipConfig)
