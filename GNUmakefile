####################################################
### A G N o S t e p  -  Desktop - by Patrick Cardona
### (c) 2026 - pcardona34 @ Github
### Author: Patrick Cardona
###
### Thanks for the GNUstep Developers Community.
### This application is free software.
### Read complete LICENSE.txt in the root directory.
####################################################

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#
VERSION = 0.3
PACKAGE_NAME = Birthday
APP_NAME = Birthday
Birthday_APPLICATION_ICON = Birthday.tiff 

#
# Resource files
#
Birthday_RESOURCE_FILES = \
Resources/Info-gnustep.plist \
Resources/Main-Window.gsmarkup \
Resources/Window.gsmarkup \
Resources/Menu-GNUstep.gsmarkup \
Resources/Menu-OSX.gsmarkup \
Resources/Birthday.tiff

#
# Header files
#
Birthday_HEADER_FILES = \
MyDelegate.h

#
# Objective-C Class files
#
Birthday_OBJC_FILES = \
MyDelegate.m

#
# Other sources
#
Birthday_OBJC_FILES += \
Main.m

#
# Localization
#
Birthday_LANGUAGES = English French
Birthday_LOCALIZED_RESOURCE_FILES = \
Main-Window.strings \
Window.strings \
Menu-GNUstep.strings \
Menu-OSX.strings \
Localizable.strings \
InfoPlist.strings \
Birthday.help

#
#  Lib Renaissance
#
ifeq ($(FOUNDATION_LIB), apple)
  ADDITIONAL_INCLUDE_DIRS += -framework Renaissance
  ADDITIONAL_GUI_LIBS += -framework Renaissance
else
  ADDITIONAL_GUI_LIBS += -lRenaissance
endif

#
# Makefiles
#
include $(GNUSTEP_MAKEFILES)/application.make
