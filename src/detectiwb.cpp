#include "detectiwb.h"
#include <usb.h>

DetectIWB::DetectIWB(QObject *parent) : QObject(parent),
  found(false)
{
    uint16_t vendors[2] = {0x6615,0x2621};
    struct usb_bus *bus;
    struct usb_device *dev;
    usb_init();
    usb_find_busses();
    usb_find_devices();
    for (bus = usb_busses; bus; bus = bus->next) {
        for (dev = bus->devices; dev; dev = dev->next) {
            if (vendors[0] == dev->descriptor.idVendor ||
                    vendors[1] == dev->descriptor.idVendor) {
                found = true;
            }
        }
    }
}


bool DetectIWB::isIWB()
{
    return this->found;
}

