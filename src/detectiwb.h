#ifndef DETECTIWB_H
#define DETECTIWB_H

#include <QObject>

class DetectIWB : public QObject
{
    Q_OBJECT
public:
    explicit DetectIWB(QObject *parent = 0);
    bool isIWB();
private:
    bool found;
    uint16_t *vendors;

};

#endif // DETECTIWB_H
