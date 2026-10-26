import 'package:get/get.dart';
import 'package:projeto_patrimonio/view/patrimonios/adicionar_patrimonio_page.dart';
import 'package:projeto_patrimonio/view/patrimonios/detalhes_patrimonio_page.dart';
import '../binding/InicialBinding.dart';
import '../binding/LoginBinding.dart';
import '../binding/PatrimonioBinding.dart';
import '../binding/UsuarioBinding.dart';
import '../view/users/gestao_professores.dart';
import '../view/login/cadastrar_prof_page.dart';
import '../view/login/login_page.dart';
import '../view/patrimonios/patrimonios_page.dart';
import '../view/login/esqueci_senha_page.dart';
import '../view/login/cadastrar_adm_page.dart';
import '../binding/PerfilBinding.dart';
import '../view/perfil/perfil_page.dart';
import '../view/users/gestao_usuarios_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      ),

    GetPage(
    name: AppRoutes.patrimonios,
    page: () => const PatrimoniosPage(),
    binding: PatrimonioBinding(),
    ),

    GetPage(
      name: '/patrimonios/detalhes',
      page: () => const DetalhesPatrimonioPage(),
      binding: PatrimonioBinding(),
      ),

      GetPage(
        name: '/patrimonio/adicionar',
        page: () => const AdicionarPatrimonioPage(),
        binding: PatrimonioBinding()
        ),

      GetPage(
      name: '/professores',
      page: () => const GestaoProfessoresPage(),
      binding: UsuarioBinding()
      ),

      GetPage(
        name: AppRoutes.esqueciSenha,
        page: () => const EsqueciSenhaPage()),

      GetPage(
        name: AppRoutes.cadastrarAdministrador,
        page: () => const CadastroAdministradorPage(),
        binding: LoginBinding(),
        ),

        GetPage(
        name: AppRoutes.cadastrarProf,
        page: () => const CadastrarProfPage(),
        binding: UsuarioBinding(),
      ),

      GetPage(
      name: AppRoutes.perfil,
      page: () => PerfilPage(),
      binding: PerfilBinding(),
    ),

    GetPage(
  name: AppRoutes.usuarios,
  page: () => const GestaoUsuariosPage(),
  binding: UsuarioBinding(),
),

  ];
}