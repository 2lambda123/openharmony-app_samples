/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import StorageModel from '../model/StorageModel'
import reminderAgent from '@ohos.reminderAgent'

@CustomDialog
export struct CustomDatePicker {
  @State hour: number = 0
  @State minute: number = 0
  @State reminderId: number = 0
  @State hourTest: string = ''
  @State minuteTest: string = ''
  private total: number
  private selectedTime: Date = new Date()
  private controller: CustomDialogController
  private countChange: (result: number) => void

  aboutToAppear() {
    this.hour = this.selectedTime.getHours()
    this.minute = this.selectedTime.getMinutes()
    this.hourTest = (this.hour > 9 ? '' : '0') + this.hour
    this.minuteTest = (this.minute > 9 ? '' : '0') + this.minute
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.hour'))
          .fontSize('20')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text($r('app.string.minute'))
          .fontSize('20')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .margin({ top: 20, bottom: 10 })

      Column() {
        TimePicker({
          selected: this.selectedTime,
        })
          .useMilitaryTime(true)
          .onChange((date) => {
            this.hour = date.hour
            this.minute = date.minute
            this.hourTest = (date.hour > 9 ? '' : '0') + date.hour
            this.minuteTest = (date.minute > 9 ? '' : '0') + date.minute
          })
      }
      .height('30%')

      Row() {
        Text($r('app.string.yes'))
          .fontSize('20')
          .margin({ right: '20%' })
          .onClick(async () => {
            let reminderRequest: reminderAgent.ReminderRequestAlarm = {
              reminderType: reminderAgent.ReminderType.REMINDER_TYPE_ALARM,
              hour: this.hour,
              minute: this.minute,
              title: '闹钟',
              maxScreenWantAgent: {
                pkgName: 'ohos.samples.etsalarmclock',
                abilityName: 'ohos.samples.etsalarmclock.MainAbility'
              },
              ringDuration: 5000
            }
            this.reminderId = await reminderAgent.publishReminder(reminderRequest)
            let dateTime = { hour: this.hourTest, minute: this.minuteTest, reminderId: this.reminderId }
            StorageModel.getInstance().putStorageValue(`alarmClock${this.total}`, dateTime)
            this.total += 1
            StorageModel.getInstance().putStorageValue('amount', this.total)
            this.controller.close()
            this.countChange(this.total)
          })

        Text($r('app.string.no'))
          .fontSize('20')
          .margin({ left: '20%' })
          .onClick(() => {
            this.controller.close()
          })
      }
      .margin({ top: 10, bottom: 20 })
    }
    .width('100%')
  }
}