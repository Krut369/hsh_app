// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'leader_auto_router.dart';

/// generated route for
/// [AttendanceMainScreen]
class AttendanceMainRoute extends PageRouteInfo<void> {
  const AttendanceMainRoute({List<PageRouteInfo>? children})
      : super(AttendanceMainRoute.name, initialChildren: children);

  static const String name = 'AttendanceMainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AttendanceMainScreen();
    },
  );
}

/// generated route for
/// [CreateNewGroupScreen]
class CreateNewGroupRoute extends PageRouteInfo<void> {
  const CreateNewGroupRoute({List<PageRouteInfo>? children})
      : super(CreateNewGroupRoute.name, initialChildren: children);

  static const String name = 'CreateNewGroupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateNewGroupScreen();
    },
  );
}

/// generated route for
/// [GroupChatScreen]
class GroupChatRoute extends PageRouteInfo<GroupChatRouteArgs> {
  GroupChatRoute({
    Key? key,
    required ChatGroup group,
    List<PageRouteInfo>? children,
  }) : super(
          GroupChatRoute.name,
          args: GroupChatRouteArgs(key: key, group: group),
          initialChildren: children,
        );

  static const String name = 'GroupChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupChatRouteArgs>();
      return GroupChatScreen(key: args.key, group: args.group);
    },
  );
}

class GroupChatRouteArgs {
  const GroupChatRouteArgs({this.key, required this.group});

  final Key? key;

  final ChatGroup group;

  @override
  String toString() {
    return 'GroupChatRouteArgs{key: $key, group: $group}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GroupChatRouteArgs) return false;
    return key == other.key && group == other.group;
  }

  @override
  int get hashCode => key.hashCode ^ group.hashCode;
}

/// generated route for
/// [HostelChatGroupsScreen]
class HostelChatGroupsRoute extends PageRouteInfo<void> {
  const HostelChatGroupsRoute({List<PageRouteInfo>? children})
      : super(HostelChatGroupsRoute.name, initialChildren: children);

  static const String name = 'HostelChatGroupsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HostelChatGroupsScreen();
    },
  );
}

/// generated route for
/// [LeaderDashboardScreen]
class LeaderDashboardRoute extends PageRouteInfo<void> {
  const LeaderDashboardRoute({List<PageRouteInfo>? children})
      : super(LeaderDashboardRoute.name, initialChildren: children);

  static const String name = 'LeaderDashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeaderDashboardScreen();
    },
  );
}

/// generated route for
/// [LeaderMainShell]
class LeaderMainShellRoute extends PageRouteInfo<void> {
  const LeaderMainShellRoute({List<PageRouteInfo>? children})
      : super(LeaderMainShellRoute.name, initialChildren: children);

  static const String name = 'LeaderMainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeaderMainShell();
    },
  );
}

/// generated route for
/// [LeaveRequestsScreen]
class LeaveRequestsRoute extends PageRouteInfo<void> {
  const LeaveRequestsRoute({List<PageRouteInfo>? children})
      : super(LeaveRequestsRoute.name, initialChildren: children);

  static const String name = 'LeaveRequestsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeaveRequestsScreen();
    },
  );
}

/// generated route for
/// [PerformanceInsightsScreen]
class PerformanceInsightsRoute
    extends PageRouteInfo<PerformanceInsightsRouteArgs> {
  PerformanceInsightsRoute({
    Key? key,
    required StudentResult result,
    List<PageRouteInfo>? children,
  }) : super(
          PerformanceInsightsRoute.name,
          args: PerformanceInsightsRouteArgs(key: key, result: result),
          initialChildren: children,
        );

  static const String name = 'PerformanceInsightsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PerformanceInsightsRouteArgs>();
      return PerformanceInsightsScreen(key: args.key, result: args.result);
    },
  );
}

class PerformanceInsightsRouteArgs {
  const PerformanceInsightsRouteArgs({this.key, required this.result});

  final Key? key;

  final StudentResult result;

  @override
  String toString() {
    return 'PerformanceInsightsRouteArgs{key: $key, result: $result}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PerformanceInsightsRouteArgs) return false;
    return key == other.key && result == other.result;
  }

  @override
  int get hashCode => key.hashCode ^ result.hashCode;
}

/// generated route for
/// [StudentResultsScreen]
class StudentResultsRoute extends PageRouteInfo<void> {
  const StudentResultsRoute({List<PageRouteInfo>? children})
      : super(StudentResultsRoute.name, initialChildren: children);

  static const String name = 'StudentResultsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StudentResultsScreen();
    },
  );
}
