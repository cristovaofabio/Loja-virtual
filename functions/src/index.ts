import * as functions from "firebase-functions"; //para criar funcoes e gatilhos
import * as admin from 'firebase-admin'; //para acessar dados do firestore
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands, CaptureRequestModel} from 'cielo';

admin.initializeApp(functions.config().firebase);

//valores criados previamente no cloud firestore:
const merchantId = functions.config().cielo.marchantid;
const merchantKey = functions.config().cielo.marchantkey;

//parametros de criacao. equivalente ao header em cURL
const cieloParametros: CieloConstructor = {
  merchantId: merchantId,
  merchantKey: merchantKey,
  sandbox: true, //ambiente de teste
  debug: true, //qualquer mensagem enviada para a cielo será mostrada. depois mudar para false!
}

const cielo = new Cielo(cieloParametros);

//onCall significa que essa funcao será acessada diretamente do app:
export const autorizarCartaoCredito = functions.https.onCall(async (data, context) => {
  //verificar se os dados necessarios para realizar a transacao foram coletados e enviados pelo app para esta funcao:
  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Dados não informados"
      }
    };
  }
  //verificar se existe algum usuario autenticado:
  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Nenhum usuário logado"
      }
    };
  }

  console.log("Iniciando Autorização");

  //variavel brand do tipo EnumBrands
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

  const usuarioId = context.auth.uid;
  const snapshot = await admin.firestore().collection("usuarios").doc(usuarioId).get();
  const dadosUsuario = snapshot.data() || {};

  //equivalente ao body em cURL para uma transacao completa. apenas alguns dados abaixo sao obrigatorios
  const saleData: TransactionCreditCardRequestModel = {
    merchantOrderId: data.merchantOrderId, //identificador do pedido, coletado e informado pelo app.
    customer: {
      name: dadosUsuario.nome,
      identity: data.cpf, //cpf do comprador, coletado e informado pelo app.
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
      amount: data.amount, //valor a ser pago, coletado e informado pelo app
      installments: data.installments,
      softDescriptor: data.softDescriptor.substring(0, 13), //utilizar apenas os 13 primeiros carateres
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
    //equivale a realizar um post em cURL. a resposta deste post sera armazenada na constate transacition
    const transaction = await cielo.creditCard.transaction(saleData);
    //de acordo com a documentacao da cielo, a resposta contem a variavel status
    if (transaction.payment.status === 1) {
      //status igual a 1 significa que o pagamento foi autorizado com sucesso!

      return {
        "success": true,
        "paymentId": transaction.payment.paymentId
      }
    } else {
      //ocorreu algum erro na autorização
      let message = '';
      //de acordo com a documentacao da cielo, a resposta contem a variavel returnCode
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

//esta funcao serve para que a cobrança da compra seja efetivada ao portador do cartão.
//de acordo com a documentacao da cielo, a cobrança poderá ser realizada em até 5 dias após a data da autorização.
export const capturarCartaoCredito = functions.https.onCall(async (data, context) => {
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

  const captureParams: CaptureRequestModel = {
    paymentId: data.payId,
  }

  try {
    const capture = await cielo.creditCard.captureSaleTransaction(captureParams);

    if (capture.status === 2) {
      return { "success": true };
    } else {
      return {
        "success": false,
        "status": capture.status,
        "error": {
          "code": capture.returnCode,
          "message": capture.returnMessage,
        }
      };
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