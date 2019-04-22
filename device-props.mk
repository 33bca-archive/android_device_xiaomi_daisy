# Setting the DPI value that is actually sane
PRODUCT_PROPERTY_OVERRIDES += \
ro.sf.lcd_density=401
# Always use GPU for screen compositing
PRODUCT_PROPERTY_OVERRIDES += \
	debug.sf.disable_hwc=1
