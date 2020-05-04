package example

import chisel3._

import freechips.rocketchip.config.{Config}

//============================================================================
// EE290 Rocket Configs
//============================================================================
class GemminiEE290Lab2RocketConfig extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithEE290Lab2GemminiConfig() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class GemminiEE290Lab2BigSPRocketConfig extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithEE290Lab2LargeSPGemminiConfig() ++ 
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class GemminiEE290Lab3RocketConfig extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithEE290Lab3GemminiConfig() ++ 
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class GemminiEE290Lab3SmallSPRocketConfig extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithEE290Lab3SmallSPGemminiConfig() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

//============================================================================
// EE290 Rocket Configs (gemmini2)
//============================================================================

class Gemmini2EE290Lab3RocketConfig extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithEE290Lab3Gemmini2Config() ++ 
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

//============================================================================
// Gemmini2 Design Space Exploration Top Level Configs
//============================================================================
class Gemmini2dim16sp64acc16bus064 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim16sp64acc16bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)
 
class Gemmini2dim32sp64acc16bus064 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim32sp64acc16bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemmini2dim16sp16acc64bus064 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim16sp16acc64bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemmini2dim32sp16acc64bus064 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim32sp16acc64bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemmini2dim16sp64acc16bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim16sp64acc16bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemmini2dim32sp64acc16bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim32sp64acc16bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemmini2dim16sp16acc64bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim16sp16acc64bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemmini2dim32sp16acc64bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemmini2dim32sp16acc64bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

//============================================================================
// Gemmini1-Reference Design Space Exploration Top Level Configs
//============================================================================
class Gemminidim16sp64acc16bus064 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim16sp64acc16bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)
 
class Gemminidim32sp64acc16bus064 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim32sp64acc16bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemminidim16sp16acc64bus064 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim16sp16acc64bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemminidim32sp16acc64bus064 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim32sp16acc64bus064() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemminidim16sp64acc16bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim16sp64acc16bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemminidim32sp64acc16bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim32sp64acc16bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemminidim16sp16acc64bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim16sp16acc64bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class Gemminidim32sp16acc64bus128 extends Config(
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithGemminidim32sp16acc64bus128() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

//============================================================================
// FgGemmini2 Design Space Exploration Top Level Configs
//============================================================================
class FgGemmini2dim32fg32 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithFgGemmini2dim32fg32() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class FgGemmini2dim32fg16 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithFgGemmini2dim32fg16() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class FgGemmini2dim32fg8 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithFgGemmini2dim32fg8() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class FgGemmini2dim16fg16 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithFgGemmini2dim16fg16() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class FgGemmini2dim16fg8 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithFgGemmini2dim16fg8() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

class FgGemmini2dim16fg4 extends Config( 
  new WithTSI ++
  new WithNoGPIO ++
  new WithBootROM ++
  new WithUART ++
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++
  new freechips.rocketchip.subsystem.WithNoSlavePort ++
  new freechips.rocketchip.subsystem.WithInclusiveCache ++
  gemmini.WithFgGemmini2dim16fg4() ++
  new freechips.rocketchip.subsystem.WithNBigCores(1) ++
  new freechips.rocketchip.system.BaseConfig)

