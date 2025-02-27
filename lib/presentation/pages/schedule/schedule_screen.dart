import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/schedule_settings_modal.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'widgets/schedule_page_view.dart';

class ScheduleScreen extends StatefulWidget {
  static const String routeName = '/schedule';
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _modalShown = false;

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  void initState() {
    super.initState();
  }

  ValueNotifier<bool> _switchValueNotifier = ValueNotifier(false);

  Widget _buildGroupButton(String group, String activeGroup, bool isActive,
      [Schedule? schedule]) {
    if (isActive) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group,
                style: DarkTextTheme.buttonL,
              ),
              Row(
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    child: const Icon(Icons.refresh_rounded),
                    shape: CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: DarkThemeColors.colorful05,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group,
                style: DarkTextTheme.buttonL,
              ),
              Row(
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      context
                          .read<ScheduleBloc>()
                          .add(ScheduleSetActiveGroupEvent(group));
                    },
                    child: const Icon(Icons.check_rounded),
                    shape: CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    child: const Icon(Icons.refresh_rounded),
                    shape: CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleDeleteEvent(
                          group: group, schedule: schedule!));
                    },
                    child: const Icon(Icons.delete_rounded),
                    shape: CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DarkThemeColors.deactive),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: _innerDrawerKey,
      offset: const IDOffset.horizontal(0.6),
      swipeChild: true,
      rightChild: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'Управление расписанием и группами',
                  style: DarkTextTheme.h6,
                ),
              ),
              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             SvgPicture.asset(
              //               'assets/icons/lessons.svg',
              //               height: 16,
              //               width: 16,
              //             ),
              //             SizedBox(width: 20),
              //             Text("Пустые пары", style: DarkTextTheme.buttonL),
              //           ],
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(right: 8),
              //           child: ValueListenableBuilder(
              //             valueListenable: _switchValueNotifier,
              //             builder: (context, hasError, child) =>
              //                 CupertinoSwitch(
              //               activeColor: DarkThemeColors.primary,
              //               value: _switchValueNotifier.value,
              //               onChanged: (value) {
              //                 _switchValueNotifier.value = value;
              //               },
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     SizedBox(height: 20),
              //     Opacity(
              //       opacity: 0.05,
              //       child: Container(
              //         width: double.infinity,
              //         height: 1,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
              BlocBuilder<ScheduleBloc, ScheduleState>(
                  buildWhen: (prevState, currentState) {
                if (currentState is ScheduleLoaded &&
                    prevState is ScheduleLoaded) {
                  if (prevState.activeGroup != currentState.activeGroup ||
                      prevState.downloadedScheduleGroups !=
                          currentState.downloadedScheduleGroups) return true;
                }
                if (currentState is ScheduleLoaded &&
                    prevState.runtimeType != ScheduleLoaded) return true;
                return false;
              }, builder: (context, state) {
                if (state is ScheduleLoaded) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/add_group.svg',
                                        height: 16,
                                        width: 16,
                                      ),
                                      SizedBox(width: 20),
                                      Text("Добавить группу",
                                          style: DarkTextTheme.buttonL),
                                    ],
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.05,
                                  child: Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (!_modalShown)
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => ScheduleSettingsModal(
                                      groups: state.groups, isFirstRun: false),
                                ).whenComplete(() {
                                  this._modalShown = false;
                                });
                              this._modalShown = true;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Группы".toUpperCase(),
                          style: DarkTextTheme.chip
                              .copyWith(color: DarkThemeColors.deactiveDarker),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        _buildGroupButton(
                            state.activeGroup, state.activeGroup, true),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.downloadedScheduleGroups.length,
                            itemBuilder: (context, index) {
                              if (state.downloadedScheduleGroups[index] !=
                                  state.activeGroup)
                                return _buildGroupButton(
                                    state.downloadedScheduleGroups[index],
                                    state.activeGroup,
                                    false,
                                    state.schedule);
                              return Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else
                  return Container();
              }),
            ],
          ),
        ),
      ),
      scaffold: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Расписание',
            style: DarkTextTheme.title,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.dehaze),
                onPressed: () {
                  _innerDrawerKey.currentState!.toggle();
                }),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ScheduleBloc, ScheduleState>(
            buildWhen: (prevState, currentState) {
              if (prevState is ScheduleLoaded && currentState is ScheduleLoaded)
                return prevState.schedule != currentState.schedule
                    ? true
                    : false;
              return true;
            },
            builder: (context, state) {
              if (state is ScheduleInitial) {
                context.read<ScheduleBloc>().add(ScheduleOpenEvent());
                return Container();
              } else if (state is ScheduleActiveGroupEmpty) {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (_) {
                    if (!_modalShown)
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ScheduleSettingsModal(
                            groups: state.groups, isFirstRun: true),
                      ).whenComplete(() {
                        this._modalShown = false;
                      });
                    this._modalShown = true;
                  },
                );

                return Container();
              } else if (state is ScheduleLoading) {
                if (_modalShown) {
                  _modalShown = false;
                  Navigator.pop(context);
                }
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: DarkThemeColors.primary,
                    strokeWidth: 5,
                  ),
                );
              } else if (state is ScheduleLoaded) {
                return SchedulePageView(schedule: state.schedule);
              } else if (state is ScheduleLoadError) {
                return Column(
                  children: [
                    Text(
                      'Упс!',
                      style: DarkTextTheme.h3,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      state.errorMessage,
                      style: DarkTextTheme.bodyBold,
                    )
                  ],
                );
              } else
                return Container();
            },
          ),
        ),
      ),
    );
  }
}
