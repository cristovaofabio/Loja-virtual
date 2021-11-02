import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands } from 'cielo';

admin.initializeApp(functions.config().firebase);

const merchantId = functions.config().cielo.marchantid;
const merchantKey = functions.config().cielo.marchantkey;

const cieloParametros: CieloConstructor = {
  merchantId: merchantId,
  merchantKey: merchantKey,
  sandbox: true, //ambiente de teste
  debug: true, //qualquer mensagem enviada para a cielo será mostrada. Depois mudar para false!
}

const cielo = new Cielo(cieloParametros);

//onCall significa que essa funcao será acessada diretamente do app:
export const autorizarCartaoCredito = functions.https.onCall(async (data, context) => {
  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Dados não informados"
      }
    };
  }
  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Nenhum usuário logado"
      }
    };
  }

  const userId = context.auth.uid;
  const snapshot = await admin.firestore().collection("usuarios").doc(userId).get();
  const dadosUsuario = snapshot.data() || {};

  console.log("Iniciando Autorização");

  let brand: EnumBrands;
  switch (data.creditCard.brand) {
    case "VISA":
      brand = EnumBrands.VISA;
      break;
    case "MASTERCARD":
      brand = EnumBrands.MASTER;
      break;
    case "AMEX":
      brand = EnumBrands.AMEX;
      break;
    case "ELO":
      brand = EnumBrands.ELO;
      break;
    case "JCB":
      brand = EnumBrands.JCB;
      break;
    case "DINERSCLUB":
      brand = EnumBrands.DINERS;
      break;
    case "DISCOVER":
      brand = EnumBrands.DISCOVERY;
      break;
    case "HIPERCARD":
      brand = EnumBrands.HIPERCARD;
      break;
    default:
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Cartão não suportado!"
        }
      };
  }
  const saleData: TransactionCreditCardRequestModel = {
    merchantOrderId: data.merchantOrderId,
    customer: {
      name: dadosUsuario.nome,
      identity: data.cpf,
      identityType: 'CPF',
      email: dadosUsuario.email,
      deliveryAddress: {
        street: dadosUsuario.endereco.rua,
        number: dadosUsuario.endereco.numero,
        complement: dadosUsuario.endereco.complemento,
        zipCode: dadosUsuario.endereco.zipCode.replace('.', '').replace('-', ''),
        city: dadosUsuario.endereco.cidade,
        state: dadosUsuario.endereco.estado,
        country: 'BRA',
        district: dadosUsuario.endereco.distrito,
      }
    },
    payment: {
      currency: 'BRL',
      country: 'BRA',
      amount: data.amount,
      installments: data.installments,
      softDescriptor: data.softDescriptor.substring(0, 13),
      type: data.paymentType,
      capture: false,
      creditCard: {
        cardNumber: data.creditCard.cardNumber,
        holder: data.creditCard.holder,
        expirationDate: data.creditCard.expirationDate,
        securityCode: data.creditCard.securityCode,
        brand: brand
      }
    }
  }
  try {
    const transaction = await cielo.creditCard.transaction(saleData);

    if (transaction.payment.status === 1) {
      //autorização realizada com sucesso

      return {
        "success": true,
        "paymentId": transaction.payment.paymentId
      }
    } else {
      //ocorreu algum erro na autorização
      
      let message = '';
      switch (transaction.payment.returnCode) {
        case '5':
          message = 'Não Autorizada';
          break;
        case '57':
          message = 'Cartão expirado';
          break;
        case '78':
          message = 'Cartão bloqueado';
          break;
        case '99':
          message = 'Timeout';
          break;
        case '77':
          message = 'Cartão cancelado';
          break;
        case '70':
          message = 'Problemas com o Cartão de Crédito';
          break;
        default:
          message = transaction.payment.returnMessage;
          break;
      }
      return {
        "success": false,
        "status": transaction.payment.status,
        "error": {
          "code": transaction.payment.returnCode,
          "message": message
        }
      }
    }
  } catch (error) {
    console.log("Error ", error);
    return {
      "success": false,
      "error": {
        "code": error,
        "message": (error as Error).message
      }
    };
  }

});

export const helloWorld = functions.https.onCall((data, context) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  return { data: "Hello from Cloud functions!" };
});

export const getDadosUsuario = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    return { "data": "Nenhum usuário logado" };
  }
  console.log(context.auth.uid);
  const snapshot = await admin.firestore().collection("usuarios").doc(context.auth.uid).get();
  console.log(snapshot.data());

  return {
    "data": snapshot.data()
  };
});

export const addInformacao = functions.https.onCall(async (data, context) => {
  console.log(data);
  const snapshot = await admin.firestore().collection("informacoes").add(data);

  return { "sucesso": snapshot.id };
});

export const onNovoPedido = functions.firestore.document("/orders/{idPedido}").onCreate((snapshot, context) => {
  const idPedido = context.params.idPedido;
  console.log(idPedido);
});