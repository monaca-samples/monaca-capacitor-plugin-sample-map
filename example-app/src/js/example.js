import { MonacaCapacitor } from 'monaca-capacitor-plugin';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    MonacaCapacitor.echo({ value: inputValue })
}
