import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/chat_thread_widget.dart';
import '/components/conversation_card_widget.dart';
import '/components/dark_switch_widget.dart';
import '/components/dropdown_edit_conversation_widget.dart';
import '/components/thread_chats_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'chat_main_model.dart';
export 'chat_main_model.dart';

class ChatMainWidget extends StatefulWidget {
  const ChatMainWidget({super.key});

  @override
  State<ChatMainWidget> createState() => _ChatMainWidgetState();
}

class _ChatMainWidgetState extends State<ChatMainWidget>
    with TickerProviderStateMixin {
  late ChatMainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatMainModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.hasActiveChat = false;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 50.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 100.0.ms,
            begin: Offset(-8.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 100.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 100.0.ms,
            begin: Offset(0.0, 12.0),
            end: Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 100.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: valueOrDefault<double>(
                  () {
                    if ((MediaQuery.sizeOf(context).width <= 571.0) &&
                        !FFAppState().expandMenu) {
                      return 0.0;
                    } else if (FFAppState().expandMenu) {
                      return 300.0;
                    } else {
                      return 72.0;
                    }
                  }(),
                  300.0,
                ),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                        child: FlutterFlowIconButton(
                          borderColor: FlutterFlowTheme.of(context).accent4,
                          borderRadius: 44,
                          borderWidth: 2,
                          buttonSize: 40,
                          fillColor: FlutterFlowTheme.of(context).accent4,
                          icon: Icon(
                            Icons.menu_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24,
                          ),
                          onPressed: () async {
                            FFAppState().expandMenu =
                                !(FFAppState().expandMenu ?? true);
                            safeSetState(() {});
                          },
                        ),
                      ),
                      MouseRegion(
                        opaque: true,
                        cursor: SystemMouseCursors.click ?? MouseCursor.defer,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              var conversationsRecordReference =
                                  ConversationsRecord.collection.doc();
                              await conversationsRecordReference
                                  .set(createConversationsRecordData(
                                userRef: currentUserReference,
                                timeCreated: getCurrentTimestamp,
                                timeEdited: getCurrentTimestamp,
                              ));
                              _model.newConversation =
                                  ConversationsRecord.getDocumentFromData(
                                      createConversationsRecordData(
                                        userRef: currentUserReference,
                                        timeCreated: getCurrentTimestamp,
                                        timeEdited: getCurrentTimestamp,
                                      ),
                                      conversationsRecordReference);
                              _model.activeChat =
                                  _model.newConversation?.reference;
                              _model.hasActiveChat = true;
                              safeSetState(() {});

                              safeSetState(() {});
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              width: valueOrDefault<double>(
                                FFAppState().expandMenu ? 136.0 : 40.0,
                                136.0,
                              ),
                              height: 40,
                              decoration: BoxDecoration(
                                color: _model.mouseRegionHovered!
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).accent1,
                                borderRadius: BorderRadius.circular(44),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    valueOrDefault<double>(
                                      FFAppState().expandMenu ? 8.0 : 0.0,
                                      0.0,
                                    ),
                                    0,
                                    valueOrDefault<double>(
                                      FFAppState().expandMenu ? 8.0 : 0.0,
                                      0.0,
                                    ),
                                    0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: _model.mouseRegionHovered!
                                            ? FlutterFlowTheme.of(context).info
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        size: 28,
                                      ),
                                    ),
                                    if (FFAppState().expandMenu)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 12, 0),
                                        child: Text(
                                          'New Chat',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Instrument Sans',
                                                color:
                                                    _model.mouseRegionHovered!
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .info
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation']!),
                                      ),
                                  ]
                                      .divide(SizedBox(width: 8))
                                      .addToStart(SizedBox(width: 4)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onEnter: ((event) async {
                          safeSetState(() => _model.mouseRegionHovered = true);
                        }),
                        onExit: ((event) async {
                          safeSetState(() => _model.mouseRegionHovered = false);
                        }),
                      ),
                      if (FFAppState().expandMenu)
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recents',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Instrument Sans',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                child: StreamBuilder<List<ConversationsRecord>>(
                                  stream: _model.conversations(
                                    overrideCache: _model.hasActiveChat != null,
                                    requestFn: () => queryConversationsRecord(
                                      queryBuilder: (conversationsRecord) =>
                                          conversationsRecord
                                              .where(
                                                'userRef',
                                                isEqualTo: currentUserReference,
                                              )
                                              .orderBy('timeEdited',
                                                  descending: true),
                                      limit: 8,
                                    ),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<ConversationsRecord>
                                        listViewConversationsRecordList =
                                        snapshot.data!;

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: listViewConversationsRecordList
                                          .length,
                                      itemBuilder: (context, listViewIndex) {
                                        final listViewConversationsRecord =
                                            listViewConversationsRecordList[
                                                listViewIndex];
                                        return Builder(
                                          builder: (context) => InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.activeChat =
                                                  listViewConversationsRecord
                                                      .reference;
                                              _model.hasActiveChat = true;
                                              safeSetState(() {});
                                            },
                                            child: wrapWithModel(
                                              model: _model
                                                  .conversationCardModels
                                                  .getModel(
                                                listViewConversationsRecord
                                                    .reference.id,
                                                listViewIndex,
                                              ),
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              updateOnChange: true,
                                              child: ConversationCardWidget(
                                                key: Key(
                                                  'Keyo4i_${listViewConversationsRecord.reference.id}',
                                                ),
                                                convoName:
                                                    listViewConversationsRecord
                                                        .name,
                                                action: () async {
                                                  await showAlignedDialog(
                                                    context: context,
                                                    isGlobal: false,
                                                    avoidOverflow: true,
                                                    targetAnchor:
                                                        AlignmentDirectional(
                                                                1, 0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    followerAnchor:
                                                        AlignmentDirectional(
                                                                -1, 0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    builder: (dialogContext) {
                                                      return Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              FocusScope.of(
                                                                      dialogContext)
                                                                  .unfocus(),
                                                          child:
                                                              DropdownEditConversationWidget(
                                                            renameAction:
                                                                () async {
                                                              await listViewConversationsRecord
                                                                  .reference
                                                                  .update(
                                                                      createConversationsRecordData(
                                                                name:
                                                                    FFAppState()
                                                                        .newName,
                                                              ));
                                                              FFAppState()
                                                                  .newName = '';
                                                              safeSetState(
                                                                  () {});
                                                            },
                                                            deleteAction:
                                                                () async {
                                                              await listViewConversationsRecord
                                                                  .reference
                                                                  .delete();
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ].divide(SizedBox(height: 8)),
                          ).animateOnPageLoad(
                              animationsMap['columnOnPageLoadAnimation']!),
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              wrapWithModel(
                                model: _model.darkSwitchModel,
                                updateCallback: () => safeSetState(() {}),
                                child: DarkSwitchWidget(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (responsiveVisibility(
                            context: context,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                              child: FlutterFlowIconButton(
                                borderColor:
                                    FlutterFlowTheme.of(context).accent4,
                                borderRadius: 44,
                                borderWidth: 2,
                                buttonSize: 40,
                                fillColor: FlutterFlowTheme.of(context).accent4,
                                icon: Icon(
                                  Icons.menu_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24,
                                ),
                                onPressed: () async {
                                  FFAppState().expandMenu =
                                      !(FFAppState().expandMenu ?? true);
                                  safeSetState(() {});
                                },
                              ),
                            ),
                          Expanded(
                            child: Text(
                              'Gemini Clone',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyM3x8dXNlcnxlbnwwfHx8fDE3MTA5NjA5MDl8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 16)),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 1000,
                          ),
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!_model.hasActiveChat)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 0),
                                        child: Text(
                                          'Hello.',
                                          style: FlutterFlowTheme.of(context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'Figtree',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                        child: Text(
                                          'How can I help you today?',
                                          style: FlutterFlowTheme.of(context)
                                              .displaySmall
                                              .override(
                                                fontFamily: 'Figtree',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .accent4,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () =>
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus(),
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              ChatThreadWidget(),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                child: Container(
                                                  width: 170,
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Bracketology',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Instrument Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Text(
                                                            'Tell me who will win March Madness',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Figtree',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (responsiveVisibility(
                                              context: context,
                                              phone: false,
                                              tablet: false,
                                            ))
                                              Expanded(
                                                child: Container(
                                                  width: 170,
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Help me Learn UX',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Instrument Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Text(
                                                            'Give me a breakdown of product design and the steps I need to take to be successful.',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Figtree',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (responsiveVisibility(
                                              context: context,
                                              phone: false,
                                              tablet: false,
                                            ))
                                              Expanded(
                                                child: Container(
                                                  width: 170,
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Create Recipe',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Instrument Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Text(
                                                            'Make me a delicious desert that resembles Cheesecake.',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Figtree',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            Expanded(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .accent4,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () =>
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus(),
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              ChatThreadWidget(),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                child: Container(
                                                  width: 170,
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Learn FlutterFlow',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Instrument Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Text(
                                                            'What are the best options for learning FlutterFlow and becoming an expert at the platform?',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Figtree',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 16)),
                                        ),
                                      ),
                                      if (responsiveVisibility(
                                        context: context,
                                        tablet: false,
                                        tabletLandscape: false,
                                        desktop: false,
                                      ))
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 12, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: 170,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Tell me a joke',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Instrument Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Text(
                                                            'Tell me a joke about a barista.',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Figtree',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: 170,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Create Recipe',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Instrument Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Text(
                                                            'Make me a delicious desert that resembles Cheesecake.',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Figtree',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 16)),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              if (_model.hasActiveChat)
                                Expanded(
                                  child: Container(
                                    width: 600,
                                    height: 400,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: wrapWithModel(
                                      model: _model.threadChatsModel,
                                      updateCallback: () => safeSetState(() {}),
                                      updateOnChange: true,
                                      child: ThreadChatsWidget(
                                        conversationRef: _model.activeChat!,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
