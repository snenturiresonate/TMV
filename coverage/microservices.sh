#!/bin/bash

# declare an array of micro-services
declare -a microServices=(
    "TMVConfigurationService,8083"
    "TrainDescriberUpdatesSplitterService,8084"
    "TrainDescriberUpdatesSteppingService,8085"
    "S3LoggingService,8086"
    "SignallingStatesService,8087"
    "MapsService,8088"
    "ScheduleMatchingService,8089"
    "TMVTimetableService,8090"
    "ScheduleService,8091"
    "TMVScheduleManipulationService,8092"
    "LiveMapViewService,8093"
    "MapConfigurationService,8094"
    "LiveMapConfigurationService,8095"
    "ActualPathService,8096"
    "PathExtrapolationService,8097"
)
