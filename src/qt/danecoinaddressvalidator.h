// Copyright (c) 2011-2014 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef DANECOIN_QT_DANECOINADDRESSVALIDATOR_H
#define DANECOIN_QT_DANECOINADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class DanecoinAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit DanecoinAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

/** Danecoin address widget validator, checks for a valid danecoin address.
 */
class DanecoinAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit DanecoinAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

#endif // DANECOIN_QT_DANECOINADDRESSVALIDATOR_H
