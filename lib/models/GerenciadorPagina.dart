import 'package:flutter/cupertino.dart';

class GerenciadorPagina{
  PageController _pageController;
  
  GerenciadorPagina(this._pageController);

  int paginaEstou = 0;

  mostrarPagina(int paginaSelecionada){
    if(paginaSelecionada==paginaEstou){
      return ;
    }
    paginaEstou = paginaSelecionada;
    _pageController.jumpToPage(paginaSelecionada);
  }

}