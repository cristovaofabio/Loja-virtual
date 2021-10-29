import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';

admin.initializeApp(functions.config().firebase);

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

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

export const addInformacao = functions.https.onCall(async (data,context)=>{
  console.log(data);
  const snapshot = await admin.firestore().collection("informacoes").add(data);
  
  return {"sucesso":snapshot.id};
});

export const onNovoPedido = functions.firestore.document("/orders/{idPedido}").onCreate((snapshot,context)=>{
  const idPedido = context.params.idPedido;
  console.log(idPedido);
});