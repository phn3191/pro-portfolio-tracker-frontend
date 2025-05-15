package model

import (
	"time"

	"gorm.io/gorm"
)

type Trophy struct {
	gorm.Model
	Description string    `json:"description"`
	TrophyDate  time.Time `json:"trophy_date"`
}
