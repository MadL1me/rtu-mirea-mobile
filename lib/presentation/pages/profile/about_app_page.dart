import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/member_info.dart';

class AboutAppPage extends StatelessWidget {
  static const String routeName = '/profile/about_app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'О приложении',
          style: DarkTextTheme.title,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Open Source', style: DarkTextTheme.h4),
              SizedBox(height: 8),
              Text(
                'Это приложение и все относящиеся к нему сервисы являются 100% бесплатными и Open Source продуктами. Мы с огромным удовольствием примем любые ваши предложения и сообщения, а также мы рады любому вашему участию в проекте!',
                style: DarkTextTheme.bodyRegular,
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Карта для приложения взята из сервиса ',
                      style: DarkTextTheme.bodyRegular,
                    ),
                    TextSpan(
                      text: 'Indoor Schemes',
                      style: DarkTextTheme.bodyRegular
                          .copyWith(color: DarkThemeColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://ischemes.ru/');
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Все новости берутся из официального сайта ',
                      style: DarkTextTheme.bodyRegular,
                    ),
                    TextSpan(
                      text: 'mirea.ru/news',
                      style: DarkTextTheme.bodyRegular
                          .copyWith(color: DarkThemeColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://mirea.ru/news/');
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Связаться с нами вы можете с помощью email: contact@mirea.ninja',
                style: DarkTextTheme.bodyRegular,
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Powered by ',
                      style: DarkTextTheme.bodyRegular,
                    ),
                    TextSpan(
                      text: 'Mirea Ninja',
                      style: DarkTextTheme.bodyRegular
                          .copyWith(color: DarkThemeColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://mirea.ninja/');
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SocialIconButton(AssetImage('assets/icons/github.png'), () {
                    launch(
                        'https://github.com/Ninja-Official/rtu-mirea-mobile');
                  }),
                  SocialIconButton(AssetImage('assets/icons/telegram.png'), () {
                    launch('https://t.me/joinchat/LyM7jcoRXUhmOGM6');
                  }),
                ],
              ),
              SizedBox(height: 24),
              Text('Разработчики', style: DarkTextTheme.h4),
              SizedBox(height: 16),
              BlocBuilder<AboutAppBloc, AboutAppState>(
                buildWhen: (prevState, currentState) {
                  if (prevState is AboutAppMembersLoadError) {
                    if (prevState.contributorsLoadError) return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state is AboutAppMembersLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: DarkThemeColors.primary,
                        strokeWidth: 5,
                      ),
                    );
                  } else if (state is AboutAppMembersLoaded) {
                    return Wrap(
                      spacing: 16.0,
                      runSpacing: 8.0,
                      children: [
                        for (var contributor in state.contributors)
                          MemberInfo(
                            username: contributor.login,
                            avatarUrl: contributor.avatarUrl,
                            profileUrl: contributor.htmlUrl,
                          ),
                      ],
                    );
                  } else if (state is AboutAppMembersLoadError) {
                    return Center(
                      child: Text(
                        'Произошла ошибка при загрузке разработчиков. Проверьте ваше интернет-соединение.',
                        style: DarkTextTheme.title,
                      ),
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(height: 24),
              Text('Патроны', style: DarkTextTheme.h4),
              SizedBox(height: 16),
              BlocBuilder<AboutAppBloc, AboutAppState>(
                buildWhen: (prevState, currentState) {
                  if (prevState is AboutAppMembersLoadError) {
                    if (prevState.patronsLoadError) return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state is AboutAppMembersLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: DarkThemeColors.primary,
                        strokeWidth: 5,
                      ),
                    );
                  } else if (state is AboutAppMembersLoaded) {
                    return Wrap(
                      spacing: 16.0,
                      runSpacing: 8.0,
                      children: List.generate(state.patrons.length, (index) {
                        return MemberInfo(
                          username: state.patrons[index].username,
                          avatarUrl: 'https://mirea.ninja/' +
                              state.patrons[index].avatarTemplate
                                  .replaceAll('{size}', '120'),
                          profileUrl: 'https://mirea.ninja/u/' +
                              state.patrons[index].username,
                        );
                      }),
                    );
                  } else if (state is AboutAppMembersLoadError) {
                    return Center(
                      child: Text(
                        'Произошла ошибка при загрузке патронов.',
                        style: DarkTextTheme.title,
                      ),
                    );
                  }
                  return Container();
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
