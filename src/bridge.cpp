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

#include "bridge.h"
#include <QProcess>
#include <QProcessEnvironment>
#include <QRegExp>
#include <QFileInfo>
#include <QDebug>

#define CALIBRATOR "xinput_calibrator"
#define TEMPORARY_FILE "/tmp/99-eta-calibration.conf"
#define DESTINATION "/usr/share/X11/xorg.conf.d/"
Bridge::Bridge(QObject *parent) :
    QObject(parent), m_device("")
{

}

Bridge::~Bridge() {

}

QString Bridge::device() const
{
    return m_device;
}

void Bridge::setDevice(const QString &dev)
{
    if(m_device.compare(dev) != 0) {
        m_device = dev;
        emit deviceChanged();
    }
}

QStringList Bridge::getDeviceList() const
{
    QProcess process;
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("LC_ALL","C");
    process.setEnvironment(env.toStringList());
    process.start(QString(CALIBRATOR) + " --list");
    process.waitForFinished(-1);
    QString out = QString::fromLatin1(process.readAllStandardOutput());
    process.close();

    return parseOutput(out);
}

void Bridge::runCalibrator()
{
    QProcess process;
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("LC_ALL","C");
    process.setEnvironment(env.toStringList());
    process.start(QString(CALIBRATOR) + " --device " + m_device + " --output-filename "
                  + QString(TEMPORARY_FILE));
    process.waitForFinished(-1);
    qDebug() << QString::fromLatin1(process.readAllStandardOutput());
    process.close();
}

void Bridge::makeCalibrationPermanent()
{
    if(QFileInfo(TEMPORARY_FILE).exists()) {
        QProcess process;
        QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
        process.setEnvironment(env.toStringList());
        process.start("pkexec cp -fr "+ QString(TEMPORARY_FILE) + " " + QString(DESTINATION)+".");
        process.waitForFinished(-1);
        qDebug() << QString::fromLatin1(process.readAllStandardOutput());
        process.close();
        emit saved();
    }
}

QStringList Bridge::parseOutput(const QString &s) const
{
    return s.split(QRegExp("[\r\n]+"), QString::SkipEmptyParts);
}
