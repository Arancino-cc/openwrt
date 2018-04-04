#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

OTHER_MENU:=Other modules

define KernelPackage/pwm-mediatek
  SUBMENU:=Other modules
  TITLE:=MT7628 PWM
  DEPENDS:=@(TARGET_ramips_mt76x8)
  KCONFIG:= \
	CONFIG_PWM=y \
	CONFIG_PWM_MEDIATEK \
	CONFIG_PWM_SYSFS=y
  FILES:= \
	$(LINUX_DIR)/drivers/pwm/pwm-mediatek.ko
  AUTOLOAD:=$(call AutoProbe,pwm-mediatek)
endef

define KernelPackage/pwm-mediatek/description
  Kernel modules for MediaTek Pulse Width Modulator
endef

$(eval $(call KernelPackage,pwm-mediatek))

define KernelPackage/sdhci-mt7620
  SUBMENU:=Other modules
  TITLE:=MT7620 SDCI
  DEPENDS:=@(TARGET_ramips_mt7620||TARGET_ramips_mt76x8||TARGET_ramips_mt7621) +kmod-mmc
  KCONFIG:= \
	CONFIG_MTK_MMC \
	CONFIG_MTK_AEE_KDUMP=n \
	CONFIG_MTK_MMC_CD_POLL=n
  FILES:= \
	$(LINUX_DIR)/drivers/mmc/host/mtk-mmc/mtk_sd.ko
  AUTOLOAD:=$(call AutoProbe,mtk_sd,1)
endef

$(eval $(call KernelPackage,sdhci-mt7620))

I2C_RALINK_MODULES:= \
  CONFIG_I2C_RALINK:drivers/i2c/busses/i2c-ralink

define KernelPackage/i2c-ralink
  $(call i2c_defaults,$(I2C_RALINK_MODULES),59)
  TITLE:=Ralink I2C Controller
  DEPENDS:=kmod-i2c-core @TARGET_ramips \
	@!(TARGET_ramips_mt7621||TARGET_ramips_mt76x8)
endef

define KernelPackage/i2c-ralink/description
 Kernel modules for enable ralink i2c controller.
endef

$(eval $(call KernelPackage,i2c-ralink))


I2C_MT7621_MODULES:= \
  CONFIG_I2C_MT7621:drivers/i2c/busses/i2c-mt7621

define KernelPackage/i2c-mt7628
  $(call i2c_defaults,$(I2C_MT7621_MODULES),59)
  TITLE:=MT7628/88 I2C Controller
  DEPENDS:=kmod-i2c-core \
	@(TARGET_ramips_mt76x8)
endef

define KernelPackage/i2c-mt7628/description
 Kernel modules for enable mt7621 i2c controller.
endef

$(eval $(call KernelPackage,i2c-mt7628))

define KernelPackage/dma-ralink
  SUBMENU:=Other modules
  TITLE:=Ralink GDMA Engine
  DEPENDS:=@TARGET_ramips
  KCONFIG:= \
	CONFIG_DMADEVICES=y \
	CONFIG_DW_DMAC_PCI=n \
	CONFIG_DMA_RALINK
  FILES:= \
	$(LINUX_DIR)/drivers/dma/virt-dma.ko \
	$(LINUX_DIR)/drivers/dma/ralink-gdma.ko
  AUTOLOAD:=$(call AutoLoad,52,ralink-gdma)
endef

define KernelPackage/dma-ralink/description
 Kernel modules for enable ralink dma engine.
endef

$(eval $(call KernelPackage,dma-ralink))

define KernelPackage/hsdma-mtk
  SUBMENU:=Other modules
  TITLE:=MediaTek HSDMA Engine
  DEPENDS:=@TARGET_ramips @TARGET_ramips_mt7621
  KCONFIG:= \
	CONFIG_DMADEVICES=y \
	CONFIG_DW_DMAC_PCI=n \
	CONFIG_MTK_HSDMA
  FILES:= \
	$(LINUX_DIR)/drivers/dma/virt-dma.ko \
	$(LINUX_DIR)/drivers/dma/mtk-hsdma.ko
  AUTOLOAD:=$(call AutoLoad,53,mtk-hsdma)
endef

define KernelPackage/hsdma-mtk/description
 Kernel modules for enable MediaTek hsdma engine.
endef

$(eval $(call KernelPackage,hsdma-mtk))

define KernelPackage/sound-mt7620
  TITLE:=MT7620 PCM/I2S Alsa Driver
  DEPENDS:=@TARGET_ramips +kmod-sound-soc-core +kmod-regmap +kmod-dma-ralink @!TARGET_ramips_rt288x
  KCONFIG:= \
	CONFIG_SND_RALINK_SOC_I2S \
	CONFIG_SND_SIMPLE_CARD \
	CONFIG_SND_SIMPLE_CARD_UTILS \
	CONFIG_SND_SOC_WM8960
  FILES:= \
	$(LINUX_DIR)/sound/soc/ralink/snd-soc-ralink-i2s.ko \
	$(LINUX_DIR)/sound/soc/generic/snd-soc-simple-card.ko \
	$(LINUX_DIR)/sound/soc/generic/snd-soc-simple-card-utils.ko \
	$(LINUX_DIR)/sound/soc/codecs/snd-soc-wm8960.ko
  AUTOLOAD:=$(call AutoLoad,90,snd-soc-wm8960 snd-soc-ralink-i2s snd-soc-simple-card)
  $(call AddDepends/sound)
endef

define KernelPackage/sound-mt7620/description
 Alsa modules for ralink i2s controller.
endef

$(eval $(call KernelPackage,sound-mt7620))

MCUIO_AUTOLOAD:= \
	mcuio \
	mcuio-hc-dev \
	mcuio-hc-drv \
	mcuio-soft-local-irq-ctrl-msg \
	mcuio-soft-hc \
	mcuio-hc-ldisc \
	regmap-mcuio-remote \
	mcuio-irq-test \
	mcuio_adc \
	gpio-mcuio \
	i2c-mcuio \
	mcuio-shields-manprobe

define KernelPackage/mcuio
  SUBMENU:=Other modules
  TITLE:=MCUIO
  DEPENDS:=+kmod-i2c-core +kmod-regmap +kmod-iio-core @(TARGET_ramips_mt76x8)
  KCONFIG:= \
        CONFIG_MCUIO \
        CONFIG_MCUIO_LDISC_HC \
        CONFIG_MCUIO_SHIELD_MANUAL_PROBE
  FILES:= \
        $(LINUX_DIR)/drivers/mcuio/mcuio.ko \
        $(LINUX_DIR)/drivers/mcuio/mcuio-hc-dev.ko \
        $(LINUX_DIR)/drivers/mcuio/mcuio-hc-drv.ko \
        $(LINUX_DIR)/drivers/mcuio/mcuio-hc-ldisc.ko \
        $(LINUX_DIR)/drivers/mcuio/mcuio-shields-manprobe.ko \
        $(LINUX_DIR)/drivers/base/regmap/regmap-mcuio-remote.ko \
        $(LINUX_DIR)/drivers/mcuio/mcuio-soft-local-irq-ctrl-msg.ko \
        $(LINUX_DIR)/drivers/mcuio/mcuio-soft-hc.ko \
        $(LINUX_DIR)/drivers/mcuio/mcuio-irq-test.ko \
		$(LINUX_DIR)/drivers/iio/adc/mcuio_adc.ko \
		$(LINUX_DIR)/drivers/gpio/gpio-mcuio.ko \
		$(LINUX_DIR)/drivers/i2c/busses/i2c-mcuio.ko
  AUTOLOAD:=$(call AutoLoad,98,$(MCUIO_AUTOLOAD))
endef

define KernelPackage/mcuio/description
  Kernel modules for MCU I/O 
endef

$(eval $(call KernelPackage,mcuio))