function calculateLuhn(n: number): number {
    let strN = n.toString();
    let checkSum = Array.from(strN)
        .reverse()
        .filter((_, i) => i % 2 == 0)
        .map(Number)
        .reduce((a, b) => a + b, 0);

    for (let i = strN.length - 2; i >= 0; i -= 2) {
        let doubleNum = parseInt(strN[i]) * 2;
        if (doubleNum > 9) {
            doubleNum = Array.from(doubleNum.toString()).map(Number).reduce((a, b) => a + b, 0);
        }
        checkSum += doubleNum;
    }
    return (checkSum * 9) % 10;
}

function generateLuhn(): string {
    let cardNumber = [Math.floor(Math.random() * 9 + 1), ...Array.from({length: 14}, () => Math.floor(Math.random() * 10))];
    let checkDigit = calculateLuhn(parseInt(cardNumber.join('')));
    cardNumber.push(checkDigit);
    let sCardNumber = cardNumber.map(String);
    return sCardNumber.join('').match(/.{1,4}/g)!.join(' ');
}

function checkCard(cardNumber: string): boolean {
    console.log(cardNumber);
    cardNumber = cardNumber.replace(" ", "");
    let checkDigit = parseInt(cardNumber.slice(-1));
    let cardNumberWithoutCheckDigit = cardNumber.slice(0, -1).split('').map(Number);
    let calculatedCheckDigit = calculateLuhn(parseInt(cardNumberWithoutCheckDigit.join('')));
    return calculatedCheckDigit === checkDigit;
}

console.assert(checkCard(generateLuhn()));
console.assert(checkCard(generateLuhn()));
console.assert(checkCard(generateLuhn()));
