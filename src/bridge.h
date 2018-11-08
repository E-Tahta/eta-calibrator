/*****************************************************************************
 *   Copyright (C) 2018 by Yunusemre Senturk                                 *
 *   <yunusemre.senturk@pardus.org.tr>                                       *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 *****************************************************************************/

#ifndef BRIDGE_H
#define BRIDGE_H

#include <QObject>
#include <QStringList>
#include <QString>

class Bridge : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString device READ device WRITE setDevice
               NOTIFY deviceChanged)
    Q_PROPERTY(bool iwb READ iwb)
    Q_PROPERTY(NOTIFY calibrationSuccess)
    Q_PROPERTY(NOTIFY calibrationFailed)
    Q_PROPERTY(NOTIFY savingSuccess)
    Q_PROPERTY(NOTIFY savingFailed)
public:
    explicit Bridge(QObject *parent = 0);
    ~Bridge();
    QString device() const;
    bool iwb() const;
    void setDevice(const QString &dev);
    Q_INVOKABLE QStringList getDeviceList() const;
    Q_INVOKABLE void runCalibrator();
    Q_INVOKABLE void makeCalibrationPermanent();
private:
    QStringList parseOutput(const QString &s) const;
    void deletePreviousConfig();
    QString m_device;
    bool m_iwb;
signals:
    void deviceChanged();
    void calibrationSuccess();
    void calibrationFailed();
    void savingSuccess();
    void savingFailed();

};

#endif // BRIDGE_H
