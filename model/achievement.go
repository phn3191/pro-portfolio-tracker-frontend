package model

import (
	"time"

	"gorm.io/gorm"
)

type Achievement struct {
	gorm.Model
	Description     string    `json:"description"`
	Impact          string    `json:"impact"`
	SkillUsed       string    `json:"skill_used"`
	AchievementDate time.Time `json:"achievement_date"`
}
